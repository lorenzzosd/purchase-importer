module Import
  class PurchaseLineWorker
    include Sidekiq::Worker

    def perform(import_purchase_id, line, line_count)
      purchase_line = Import::PurchaseLine.new(
        import_purchase_id: import_purchase_id
      )

      begin
        result = ProcessPurchaseLineService.perform!(line)

        if result.success?
          purchase_line.purchase = result.purchase
          purchase_line.state = :completed
        else
          purchase_line.message = error_message(line_count, result.purchase.erros)
          purchase_line.state = :error
        end
      rescue => e
        purchase_line.message = error_message(line_count, e.message)
        purchase_line.state = :error
      end

      purchase_line.save
    end

    private

    def error_message(line_count, message)
      "Line - #{line_count}: #{message}"
    end
  end
end
