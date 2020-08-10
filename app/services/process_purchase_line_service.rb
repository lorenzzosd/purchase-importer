class ProcessPurchaseLineService
  attr_reader *%i[splited_line]

  def self.perform!(line)
    new(line).perform!
  end

  def initialize(line)
    @splited_line = line.split("\t")
  end

  def perform!
    ActiveRecord::Base.transaction do
      customer = find_or_create_customer
      item = find_or_create_item
      merchant = find_or_create_merchant
      purchase = build_purchase(item, customer, merchant)

      OpenStruct.new({ purchase: purchase, success?: purchase.save })
    end
  end

  private

  def find_or_create_item
    Item.find_or_create_by!(
      { description: splited_line[1], price: splited_line[2]}
    )
  end

  def find_or_create_customer
    Customer.find_or_create_by!(name: splited_line[0])
  end

  def find_or_create_merchant
    Merchant.find_or_create_by!(
      { address: splited_line[4], name: splited_line[5] }
    )
  end

  def build_purchase(item, customer, merchant)
    ::Purchase.new(
      purchase_count: splited_line[3].to_i,
      item: item,
      customer: customer,
      merchant: merchant
    )
  end
end
