# rspec app_spec.rb

require 'rspec'

require_relative './app.rb'

RSpec.describe "Prices calculator", type: :model do
  let(:data)          { JSON.parse(File.read('data.json'), :symbolize_names => true) }
  let(:output)        { JSON.parse(File.read('output.json'), :symbolize_names => true) }

  it "parses json" do
    parse_data(data)
    expect(@practitioners_hash.values.count).to eq 4
    expect(@practitioners_hash[1].first_name).to eq "Gregory"
  end
  it "calculates prices" do
    c = Communication.new(
      {
        id: 1,
        practitioner_id: 1,
        pages_number: 2,
        color: true,
        sent_at: "2019-01-01"
      },
      {
        1=> Practitioner.new(
          {
            id: 1,
            first_name: 'test',
            last_name: 'test',
            express_delivery: true
          }
        )
      }
    )

    expect(c.calculate).to eq BASE_PRICE + ADDITIONNAL_PAGE_PRICE + COLOR_PRICE + EXPRESS_PRICE

    c.color = false
    expect(c.calculate).to eq BASE_PRICE + ADDITIONNAL_PAGE_PRICE + EXPRESS_PRICE

    c.practitioner.express_delivery = false
    expect(c.calculate).to eq BASE_PRICE + ADDITIONNAL_PAGE_PRICE
  end
  it "generates correct json" do
    parse_data(data)
    expect(prices_by_day).to eq output
  end
end
