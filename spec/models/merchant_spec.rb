require 'rails_helper'

describe Merchant do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:purchases) }
  end
end
