$:.unshift File.join(File.dirname(__FILE__), '/../lib')
require 'google/reader'
require 'yaml'
require 'pp'

config = YAML::load(open("#{ENV['HOME']}/.google"))
Google::Base.establish_connection(config[:email], config[:password])

search = Google::Reader::Search.new('john nunemaker')
results = search.results(:start => 0)
puts results.total
results.each { |r| puts r.title }
search.results(:start => 20).each { |r| puts r.title }