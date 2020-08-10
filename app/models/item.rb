class Item < ApplicationRecord
  has_many :purchases

  validates :description, :price, presence: true
end
