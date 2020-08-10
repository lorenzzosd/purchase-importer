class CreateItem < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.string :description
      t.decimal :price

      t.index %i[description price]

      t.timestamps
    end
  end
end
