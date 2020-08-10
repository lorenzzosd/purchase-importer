class Customer < ApplicationRecord
  has_many :purchases

  validates :name, presence: true
end
