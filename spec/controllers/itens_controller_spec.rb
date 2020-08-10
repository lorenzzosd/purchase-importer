require 'rails_helper'

RSpec.describe ItensController do
  describe 'GET #index' do
    let!(:item) { Item.create(price: 10, description: 'description') }

    it 'retorna lista de itens' do
      get :index

      expect(assigns(:itens)).to eq(Item.all)
    end

    it 'renderiza template' do
      get :index

      expect(response).to render_template('index')
    end
  end
end
