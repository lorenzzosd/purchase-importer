require 'rails_helper'

RSpec.describe CustomersController do
  describe 'GET #index' do
    let!(:customer) { Customer.create(name: 'name') }

    it 'retorna lista de customers' do
      get :index

      expect(assigns(:customers)).to eq(Customer.all)
    end

    it 'renderiza template' do
      get :index

      expect(response).to render_template('index')
    end
  end
end
