module Import
  class Purchase < ApplicationRecord
    include AASM

    has_many :lines,
             class_name: 'Import::PurchaseLine',
             dependent: :destroy,
             foreign_key: 'import_purchase_id'
    has_many :purchases, through: :lines

    has_one_attached :file

    validate :has_attached?, on: :create

    after_create :enqueue_import_purchase_worker

    aasm column: :state do
      state :waiting, initial: true
      state :processing
      state :completed
      state :completed_with_errors
      state :error

      event :process, before_transaction: :set_executed_on do
        transitions from: :waiting, to: :processing
      end

      event :complete do
        transitions from: :processing, to: :completed
      end

      event :complete_with_errors do
        transitions from: :processing, to: :completed_with_errors
      end

      event :error do
        transitions from: :waiting, to: :error
        transitions from: :processing, to: :error
      end
    end

    private

    def enqueue_import_purchase_worker
      Import::PurchaseWorker.perform_in(2.seconds, id)
    end

    def has_attached?
      return if file.attached?

      errors.add :file, 'not attached'
    end

    def set_executed_on
      update(executed_on: Date.current)
    end
  end
end
