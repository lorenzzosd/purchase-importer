require 'rails_helper'

describe Import::Purchase do
  describe 'associations' do
    it do
      is_expected.to(
        have_many(:lines).
        class_name('Import::PurchaseLine').
        dependent(:destroy).
        with_foreign_key('import_purchase_id')
      )
    end
    it { is_expected.to have_many(:purchases) }
  end

  describe 'validations' do
    subject(:purchase) { described_class.new(file: file) }

    context 'quando a purchase não tem file' do
      let(:file) { nil }

      it 'deve ser inválido' do
        expect(purchase).to be_invalid
      end

      it 'deve possuir messagem de erro' do
        purchase.valid?

        expect(purchase.errors).to(
          be_added(:file, 'not attached')
        )
      end
    end

    context 'quando a purchase tem file' do
      let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }

      it 'deve ser inválido' do
        expect(purchase).to be_valid
      end
    end
  end

  describe 'aasm transitions' do
    it { is_expected.to transition_from(:waiting).to(:processing).on_event(:process) }
    it { is_expected.to transition_from(:waiting).to(:error).on_event(:error) }
    it { is_expected.to transition_from(:processing).to(:completed).on_event(:complete) }
    it { is_expected.to transition_from(:processing).to(:completed_with_errors).on_event(:complete_with_errors) }
    it { is_expected.to transition_from(:processing).to(:error).on_event(:error) }
  end

  describe 'callbacks' do
    context 'after_create' do
      let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }

      subject(:purchase) { described_class.new(file: file) }

      it 'deve chamar metodo enqueue_import_purchase_worker' do
        expect(subject).to receive(:enqueue_import_purchase_worker).once

        subject.save
      end
    end
  end
end

