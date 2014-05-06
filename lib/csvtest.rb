require 'net/http'
require 'uri'
require 'date'
require 'json'
require 'oauth'
require 'debugger'
require 'csv'

arr = [{name: "b", age: "13"},{name: "c", age: "13"}]

puts arr

CSV.open("test.csv","w") do |csv|
  csv << arr[0].keys
  arr.each do |val|
    csv << CSV::Row.new(val.keys, val.values)
  end
end