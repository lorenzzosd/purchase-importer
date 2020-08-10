require 'rails_helper'

RSpec.describe PurchasesController do
  describe 'GET #index' do
    let(:customer) { Customer.create(name: 'name') }
    let(:item) { Item.create(price: 10, description: 'description') }
    let(:merchant) { Merchant.create(name: 'name', address: 'address') }
    let!(:purchase) { Purchase.create(item: item, customer: customer, merchant: merchant) }

    it 'retorna lista de purchases' do
      get :index

      expect(assigns(:purchases)).to eq(Purchase.all)
    end

    it 'renderiza template' do
      get :index

      expect(response).to render_template('index')
    end
  end
end
