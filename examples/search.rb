$:.unshift File.join(File.dirname(__FILE__), '/../lib')
require 'google/reader'
require 'pp'
require 'yaml'

config = YAML::load(open("#{ENV['HOME']}/.google"))
Google::Base.establish_connection(config[:email], config[:password])

search = Google::Reader::Search.new('test')
search.execute
pp search.results