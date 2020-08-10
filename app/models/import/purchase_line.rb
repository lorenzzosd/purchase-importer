module Import
  class PurchaseLine < ApplicationRecord
    include AASM

    belongs_to :import_purchase, class_name: 'Import::Purchase'
    belongs_to :purchase, class_name: '::Purchase', optional: true

    aasm column: :state do
      state :waiting, initial: true
      state :completed
      state :error

      event :complete do
        transitions from: :waiting, to: :completed
      end

      event :error do
        transitions from: :waiting, to: :error
      end
    end

    scope :failed, -> { where(state: :error) }
  end
end
