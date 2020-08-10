require 'rails_helper'

describe ProcessPurchaseLineService do
  let(:line) { "Amy Pond	R$30 of awesome for R$10	10.0	5	456 Unreal Rd	Tom's Awesome Shop" }

  subject { described_class.new(line) }

  describe '.perform!' do
    it 'deve instanciar class' do
      expect(described_class).to(
        receive(:new).with(line)
      ).and_call_original

      described_class.perform!(line)
    end

    it 'deve rodar o metodo perform' do
      expect_any_instance_of(described_class).to(
        receive(:perform!)
      )

      described_class.perform!(line)
    end
  end

  describe '#perform!' do
    context 'quando existe customer' do
      before { Customer.create(name: 'Amy Pond') }

      it 'não deve criar um novo customer' do
        expect { subject.perform! }.not_to change { Customer.count }
      end
    end

    context 'quando não existe customer' do
      before { Customer.destroy_all }

      it 'deve criar um novo customer' do
        expect { subject.perform! }.to change { Customer.count }.by(1)
      end
    end

    context 'quando existe item' do
      before { Item.create(description: 'R$30 of awesome for R$10', price: 10.0) }

      it 'não deve criar um novo item' do
        expect { subject.perform! }.not_to change { Item.count }
      end
    end

    context 'quando não existe item' do
      before { Item.destroy_all }

      it 'deve criar um novo item' do
        expect { subject.perform! }.to change { Item.count }.by(1)
      end
    end

    context 'quando existe merchant' do
      before { Merchant.create(address: '456 Unreal Rd', name: "Tom's Awesome Shop") }

      it 'deve criar um novo merchant' do
        expect { subject.perform! }.not_to change { Merchant.count }
      end
    end

    context 'quando não existe merchant' do
      before { Merchant.destroy_all }

      it 'não deve criar um novo merchant' do
        expect { subject.perform! }.to change { Merchant.count }.by(1)
      end
    end

    it 'deve retornar open struct com uma purchase' do
      result = subject.perform!

      expect(result.purchase).to be_a(Purchase)
    end

    it 'deve retornar open struct com um boolena' do
      result = subject.perform!

      expect(result.success?).to be_in([true, false])
    end
  end
end
