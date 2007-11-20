require 'ostruct'
module Google
  module Reader
    class Count < Base
      class << self
        # Gets all the unread counts
        # Usage:
        #   Google::Reader::Count.all
        #
        # Returns and array of open structs with each entry looking like one of the following:
        #   #<OpenStruct google_id="feed/http://feeds.feedburner.com/johnnunemaker", count=0>   # => feed
        #   #<OpenStruct google_id="user/{user_id}/label/friends", count=0>                     # => label
        def all
          parse_json(get(UNREAD_COUNT_URL))['unreadcounts'].inject([]) do |counts, c|
            counts << OpenStruct.new(:google_id => c['id'], :count => c['count'])
          end
        end
        
        # Gets all the unread counts, selects all the labels and converts them to Label objects
        # Usage:
        #   Google::Reader::Count.labels
        #
        # Returns an array of these:
        #   #<Google::Reader::Label:0x14923ec @count=0, @name="friends", @shared=false>
        def labels
          all.select { |c| c.google_id =~ /^user/ }.collect { |c| Label.new(c.google_id, nil, c.count) }
        end
        
        # Gets all the unread counts and selects all the feeds
        # Usage:
        #   Google::Reader::Count.feeds
        #
        # Returns and array of these:
        #   #<OpenStruct google_id="feed/http://feeds.feedburner.com/johnnunemaker", count=0>
        def feeds
          all.select { |c| c.google_id =~ /^feed/ }
        end
      end
    end
  end
end