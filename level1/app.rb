require "json"
require 'date'
#constants
BASE_PRICE = 0.10
COLOR_PRICE = 0.18
ADDITIONNAL_PAGE_PRICE = 0.07
EXPRESS_PRICE = 0.6

#variables
@practitioners_hash = {}
@communications_hash = {}

#classes
class Practitioner
  attr_accessor :id, :first_name, :last_name, :express_delivery

  def initialize(item)
    item.each_pair{|k,v| self.send("#{k}=", v)}
  end
end
class Communication
  attr_accessor :id, :practitioner_id, :pages_number, :color, :sent_at, :practitioner

  def initialize(item, practitioners)
    item.each_pair{|k,v| self.send("#{k}=", v)}
    @practitioner=practitioners[practitioner_id]
    @sent_at=DateTime.parse(item[:sent_at])
  end
  def calculate
    result = BASE_PRICE
    result += ((pages_number-1)*ADDITIONNAL_PAGE_PRICE)
    result += (COLOR_PRICE) if color
    result += (EXPRESS_PRICE) if practitioner.express_delivery
    result
  end

end

def parse_data raw
  @practitioners_hash = raw[:practitioners].map { |item| [item[:id], Practitioner.new(item)] }.to_h
  @communications_hash = raw[:communications].map { |item| [item[:id], Communication.new(item, @practitioners_hash)] }.to_h
end

def prices_by_day
  result = {
    totals: []
  }
  sum = {}
  @communications_hash.values.each do |comm|
    day = comm.sent_at.to_date.to_s
    sum[day] ||= 0
    sum[day] += comm.calculate
  end
  sum.each_pair do |k,v|
    result[:totals] << {sent_on: k, total: v.round(2)}
  end
  result
end

#Main code
data_hash = JSON.parse(File.read('data.json'), :symbolize_names => true)
parse_data(data_hash)

puts prices_by_day.inspect
