class ItensController < ApplicationController
  def index
    @itens = Item.all
  end
end
