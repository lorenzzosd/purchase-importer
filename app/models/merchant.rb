class Merchant < ApplicationRecord
  has_many :purchases

  validates :name, :address, presence: true
end
