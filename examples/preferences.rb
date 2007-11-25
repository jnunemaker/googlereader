$:.unshift File.join(File.dirname(__FILE__), '/../lib')
require 'google/reader'
require 'pp'
require 'yaml'

config = YAML::load(open("#{ENV['HOME']}/.google"))
Google::Base.establish_connection(config[:email], config[:password])

pp Google::Reader::Preference.available
pp Google::Reader::Preference[:design]
pp Google::Reader::Preference[:mobile_use_transcoder]
pp Google::Reader::Preference[:mobile_num_entries]

pp Google::Reader::Preference.stream