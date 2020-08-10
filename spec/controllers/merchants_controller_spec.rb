require 'rails_helper'

RSpec.describe MerchantsController do
  describe 'GET #index' do
    let!(:merchant) { Merchant.create(name: 'name', address: 'address') }

    it 'retorna lista de merchants' do
      get :index

      expect(assigns(:merchants)).to eq(Merchant.all)
    end

    it 'renderiza template' do
      get :index

      expect(response).to render_template('index')
    end
  end
end
