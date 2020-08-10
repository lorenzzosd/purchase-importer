class CreateImportPurchaseLine < ActiveRecord::Migration[5.2]
  def change
    create_table :import_purchase_lines do |t|
      t.references :import_purchase
      t.references :purchase
      t.string :state
      t.text :message

      t.timestamps
    end
  end
end
