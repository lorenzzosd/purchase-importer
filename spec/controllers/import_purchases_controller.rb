require 'rails_helper'

RSpec.describe ImportPurchasesController do
  describe 'GET #index' do
    let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }
    let!(:import_purchase) { Import::Purchase.create(file: file) }

    it 'retorna lista de imports_purchases' do
      get :index

      expect(assigns(:imports_purchases)).to eq(Import::Purchase.all)
    end

    it 'retorna nova istancia de Import::Purchase' do
      get :index

      expect(assigns(:import_purchase)).to be_a(Import::Purchase)
    end

    it 'renderiza template' do
      get :index

      expect(response).to render_template('index')
    end
  end

  describe 'POST #create' do
    context 'quando possui file' do
      subject! do
        post :create, params: {
          import_purchase: {
            file: fixture_file_upload(Rails.root.join('example_input.tab')),
            name: 'name'
          }
        }
      end

      it { expect(flash.now[:notice]).to eql({ Import::Purchase.model_name.human => ['Success created'] }) }
    end
  end

  describe 'GET #show' do
    let(:file) { fixture_file_upload(Rails.root.join('example_input.tab')) }
    let!(:import_purchase) { Import::Purchase.create(file: file) }

    it 'retorna import_purchase' do
      get :show, params: { id: import_purchase.id }

      expect(assigns(:import_purchase)).to eq(import_purchase)
    end
  end
end
