require 'rails_helper'

describe 'Communication API endpoint' do

  describe "#index" do

    it 'serializes correctly' do
      name = Faker::Name.name.split ' '
      practitioner = Practitioner.create(first_name: name.first, last_name: name.last)
      communication = Communication.create(practitioner: practitioner, sent_at: Time.at(rand * Time.now.to_f))

      get "/api/communications", {}
      expect(JSON.parse(response.body)[0]['first_name']).to eq name.first
      expect(JSON.parse(response.body)[0]['last_name']).to eq name.last
    end
  end
  describe "#create" do

    it 'creates correctly' do
      name = Faker::Name.name.split ' '
      practitioner = Practitioner.create(first_name: name.first, last_name: name.last)

      post "/api/communications", params: {communication: {first_name: name.first, last_name: name.last, sent_at: DateTime.now}}
      expect(Communication.count).to eq 1
    end
  end
end
