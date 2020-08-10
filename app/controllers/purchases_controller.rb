class PurchasesController < ApplicationController
  def index
    @purchases = Purchase.preload(:item, :customer, :merchant).all
  end
end
