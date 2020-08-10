class CreatePurchase < ActiveRecord::Migration[5.2]
  def change
    create_table :purchases do |t|
      t.references :customer
      t.references :item
      t.references :merchant

      t.integer :purchase_count

      t.timestamps
    end
  end
end
