class Purchase < ApplicationRecord
  belongs_to :customer
  belongs_to :item
  belongs_to :merchant

  def gross_income
    return 0 unless item.present?

    item.price * purchase_count
  end
end
