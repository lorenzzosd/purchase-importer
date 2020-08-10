class CreateImportPurchase < ActiveRecord::Migration[5.2]
  def change
    create_table :import_purchases do |t|
      t.string :state
      t.string :name
      t.date :executed_on

      t.timestamps
    end
  end
end
