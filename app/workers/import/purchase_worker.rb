module Import
  class PurchaseWorker
    include Sidekiq::Worker

    def perform(import_purchase_id)
      import_purchase = ::Import::Purchase.find(import_purchase_id)

      batch = sidekiq_batch(import_purchase)

      import_purchase.process!

      begin
        batch.jobs do
          import_purchase.file_blob.open(tmpdir: '/tmp') do |file|
            File.open(file.path, 'r').each_with_index do |line, index|
              unless index.zero?
                Import::PurchaseLineWorker.perform_async(
                  import_purchase_id, line, index
                )
              end
            end
          end
        end
      rescue => e
        import_purchase.error!
      end
    end

    private

    def sidekiq_batch(import_purchase)
      batch = Sidekiq::Batch.new
      batch.on(
        :complete,
        Import::PurchaseCallback,
        import_purchase_id: import_purchase.id
      )

      batch
    end
  end
end
