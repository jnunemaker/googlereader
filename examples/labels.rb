$:.unshift File.join(File.dirname(__FILE__), '/../lib')
require 'google/reader'
require 'pp'
require 'yaml'

config = YAML::load(open("#{ENV['HOME']}/.google"))
Google::Base.establish_connection(config[:email], config[:password])
# Google::Base.set_connection(Google::Base.new(config[:email], config[:password]))

puts '', '=Labels='
labels = Google::Reader::Label.all
pp labels

# puts '', '==Ruby on Rails=='
# unread = Google::Reader::Label.new('ruby-on-rails').entries(:unread, :n => 5)
# pp unread.first
# 
# puts '', '===Using Continuation==='
# more_unread = Google::Reader::Label.new('links').entries(:unread, :n => 5, :c => unread.continuation)
# more_unread.each { |p| puts p.title }