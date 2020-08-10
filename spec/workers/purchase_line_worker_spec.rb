require 'rails_helper'

describe Import::PurchaseLineWorker do
  subject { described_class.new }

  describe '#perform' do
    let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }
    let(:import_purchase) { Import::Purchase.create(file: file) }
    let(:line) { "Amy Pond	R$30 of awesome for R$10	10.0	5	456 Unreal Rd	Tom's Awesome Shop" }

    it 'deve intanciar um Import::PurchaseLine' do
      expect(Import::PurchaseLine).to(
        receive(:new).with(import_purchase_id: import_purchase.id).
        and_call_original
      )

      subject.perform(import_purchase.id, line, 1)
    end

    it 'deve chamar o serviço ProcessPurchaseLineService' do
      expect(ProcessPurchaseLineService).to(
        receive(:perform!).with(line).
        and_call_original
      )

      subject.perform(import_purchase.id, line, 1)
    end

    context 'quando o resultado é sucesso' do
      before { subject.perform(import_purchase.id, line, 1) }

      it 'deve associar purchase com a purchase_line' do
        expect(import_purchase.lines.last.purchase.present?).to be_truthy
      end

      it 'deve atualizar o state da purchase_line pra completed' do
        expect(import_purchase.lines.last.state).to be_eql('completed')
      end
    end

    context 'quando o resultado é falha' do
      let(:line) { "" }

      before { subject.perform(import_purchase.id, line, 1) }

      it 'não deve associar purchase com a purchase_line' do
        expect(import_purchase.lines.last.purchase.present?).to be_falsey
      end

      it 'deve atualizar o state da purchase_line pra error' do
        expect(import_purchase.lines.last.state).to be_eql('error')
      end
    end
  end
end
