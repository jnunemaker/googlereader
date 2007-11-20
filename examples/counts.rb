$:.unshift File.join(File.dirname(__FILE__), '/../lib')
require 'google/reader'

require 'pp'
require 'yaml'
config = YAML::load(open("#{ENV['HOME']}/.google"))

Google::Base.establish_connection(config[:email], config[:password])

# pp Google::Reader::Count.all
pp Google::Reader::Count.labels
# pp Google::Reader::Count.feeds