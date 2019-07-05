require "json"
BASE_PRICE = 0.10
COLOR_PRICE = 0.18
ADDITIONNAL_PAGE_PRICE = 0.07
EXPRESS_PRICE = 0.6

class Practitioner
  attr_accessor :id, :first_name, :last_name, :express_delivery

  def initialize(item)
    item.each_pair{|k,v| self.send("#{k}=", v)}
  end
end
class Communication
  attr_accessor :id, :practitioner_id, :pages_number, :color, :sent_at

  def initialize(item)
    item.each_pair{|k,v| self.send("#{k}=", v)}
  end
end

#Data parsing
data_hash = JSON.parse(File.read('data.json'), :symbolize_names => true)
practitioners_hash = data_hash[:practitioners].map { |item| [item[:id], Practitioner.new(item)] }.to_h
communications_hash = data_hash[:communications].map { |item| [item[:id], Communication.new(item)] }.to_h

