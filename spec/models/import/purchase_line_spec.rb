require 'rails_helper'

describe Import::PurchaseLine do
  describe 'associations' do
    it { is_expected.to belong_to(:import_purchase).class_name('Import::Purchase') }
    it { is_expected.to belong_to(:purchase).class_name('::Purchase').optional }
  end

  describe 'aasm transitions' do
    it { is_expected.to transition_from(:waiting).to(:completed).on_event(:complete) }
    it { is_expected.to transition_from(:waiting).to(:error).on_event(:error) }
  end

  describe 'scopes' do
    describe '.failed' do
      let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }
      let(:import_purchase) { Import::Purchase.create(file: file) }
      let!(:import_purchase_line_failed) do
        Import::PurchaseLine.create(import_purchase: import_purchase, state: :error)
      end
      let!(:import_purchase_line_success) do
        Import::PurchaseLine.create(import_purchase: import_purchase, state: :complete)
      end

      subject { described_class.failed }

      it 'deve incluir registro falho' do
        is_expected.to include import_purchase_line_failed
      end

      it 'não deve incluir registro de sucesso' do
        is_expected.not_to include import_purchase_line_success
      end
    end
  end
end

