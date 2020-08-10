require 'rails_helper'

describe Import::PurchaseCallback do
  describe '#on_complete' do
    let(:status) { double(:status) }
    let(:options) { { 'import_purchase_id' => 1 } }

    subject { described_class.new.on_complete(status, options) }

    context 'quando o status tem falhas' do
      before { allow(status).to receive(:failures).and_return(2) }

      it 'deve levantar error' do
        expect { subject }.to(
          raise_error(
            an_instance_of(Import::ProcessFail).and(
              have_attributes(message: '1')
            )
          )
        )
      end
    end

    context 'quando o status não tem falhas' do
      let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }
      let(:import_purchase) { Import::Purchase.create(file: file, state: :processing) }

      before do
        allow(status).to receive(:failures).and_return(0)
        allow(Import::Purchase).to(
          receive(:find).with(1).and_return(import_purchase)
        )
      end

      it 'deve buscar a importação' do
        expect(Import::Purchase).to receive(:find).with(1)

        subject
      end

      context 'e a importação não tem errors' do
        before do
          allow(import_purchase).to(
            receive_message_chain(
              :lines, :failed, :any?
            ).and_return(false)
          )
        end

        it 'deve atualizar status da importação para completo' do
          expect(import_purchase).to receive(:complete!)

          subject
        end
      end

      context 'e a importação tem errors' do
        before do
          allow(import_purchase).to(
            receive_message_chain(
              :lines, :failed, :any?
            ).and_return(true)
          )
        end

        it 'deve atualizar status da importação para completo com erros' do
          expect(import_purchase).to receive(:complete_with_errors!)

          subject
        end
      end
    end
  end
end
