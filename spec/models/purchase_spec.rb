require 'rails_helper'

describe Purchase do
  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:item) }
    it { is_expected.to belong_to(:merchant) }
  end

  describe '#gross_income' do
    subject(:purchase) do
      Purchase.new(item: item, purchase_count: 2)
    end

    context 'quando não possui item associado' do
      let(:item) { nil }

      it 'deve retornar 0' do
        expect(purchase.gross_income).to be_zero
      end
    end

    context 'quando não possui item associado' do
      let(:item) { Item.new(price: 10) }

      it 'deve retornar 0' do
        expect(purchase.gross_income).to be_eql(item.price * purchase.purchase_count)
      end
    end
  end
end
