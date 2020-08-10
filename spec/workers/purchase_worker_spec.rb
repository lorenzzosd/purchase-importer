require 'rails_helper'

describe Import::PurchaseWorker do
  subject { described_class.new }

  describe '#perform' do
    let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }
    let(:import_purchase) { Import::Purchase.create(file: file) }
    let(:batch) { Sidekiq::Batch.new }

    before do
      allow(Sidekiq::Batch).to receive(:new).and_return(batch)
    end

    it 'deve buscar o import purchase' do
      expect(Import::Purchase).to(
        receive(:find).with(import_purchase.id).and_call_original
      )

      subject.perform(import_purchase.id)
    end

    it 'deve criar um batch com o callback Import::PurchaseCallback' do
      expect(batch).to receive(:on).with(
        :complete,
        Import::PurchaseCallback,
        import_purchase_id: import_purchase.id
      )

      subject.perform(import_purchase.id)
    end

    it 'deve atualizar o status da atualização do import purchase para processing' do
      subject.perform(import_purchase.id)

      expect(import_purchase.reload.state).to be_eql('processing')
    end

    it 'deve enfilerar os jobs de purchase line' do
      expect(Import::PurchaseLineWorker).to(
        receive(:perform_async).
          with(import_purchase.id, anything, anything)
      ).exactly(4).times

      subject.perform(import_purchase.id)
    end
  end
end
