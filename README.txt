= Installation

sudo gem install googlereader

= Usage

  require 'google/reader'
  Google::Reader::Base.establish_connection('username', 'password')

  # => all feeds and labels unread counts
  pp Google::Reader::Count.all

  # => all unread counts for labels
  pp Google::Reader::Count.labels

  # => all unread counts for feeds
  pp Google::Reader::Count.feeds

  # => all items for a label
  pp Google::Reader::Label.all
  
  puts 'Links'
  # 5 latest unread items
  unread = Google::Reader::Label.new('links').entries(:unread, :n => 5) 
  unread.each { |p| puts p.title }
  
  puts 'Using Continuation'
  # next 5 latest items after the unread above
  more_unread = Google::Reader::Label.new('links').entries(:unread, :n => 5, :c => unread.continuation) 
  more_unread.each { |p| puts p.title }
	
= Notes

I'm using the following links below as documentation (and also a bit of reverse engineering with Firebug) until google releases an official and documented api:

* http://code.google.com/p/pyrfeed/wiki/GoogleReaderAPI
* http://blog.gpowered.net/2007/08/google-reader-api-functions.html