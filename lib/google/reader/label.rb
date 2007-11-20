module Google
  module Reader
    class Label < Base
      class << self
        # Usage:
        #   Google::Reader::Label.all
        def all
          parse_json(get(LABELS_URL))['tags'].inject([]) do |labels, l|
            labels << new(l['id'], l['shared'])
          end
        end
      end
      
      VALID_KEYS = [:n, :c]
      
      attr_reader :shared
      attr_accessor :count
      
      # Usage:
      #   Google::Reader::Label.new('friends')
      #   Google::Reader::Label.new('friends', false)
      #   Google::Reader::Label.new('friends', false, 3)
      def initialize(name, shared=false, count=0)
        self.name   = name
        self.shared = shared
        self.count  = count
      end
      
      # Converts user/{user-id}/label/security to security.
      def name=(new_name)
        @name = new_name.split('/').last
      end
      
      # Returns name; converts broadcast label to shared to be consistent with google
      def name
        @name == 'broadcast' ? 'shared' : @name
      end
      
      def shared=(new_shared)
        if new_shared.is_a?(String)
          @shared = new_shared == 'no' ? false : true
        else
          @shared = new_shared.nil? ? false : true
        end
      end
      
      # Usage:
      #   Google::Reader::Label.new('friends').entries
      #   Google::Reader::Label.new('friends').entries(:all, :n => 25)
      #   Google::Reader::Label.new('friends').entries(:unread)
      #   Google::Reader::Label.new('friends').entries(:unread, :n => 25)
      #
      # To use with continuations:
      #   unread      = Google::Reader::Label.new('friends').entries(:unread)
      #   next_unread = Google::Reader::Label.new('friends').entries(:unread, :c => unread.continuation)
      #
      # The examples above would grab the first 15 unread entries and then using google reader's 
      # continuations, the next 15 unread after the first 15.
      def entries(which=nil, o={})
        options = {:n => 15,}.merge(o)
        query_str = valid_keys_to_query_string(o)
        url = case which
        when :unread
          sprintf(LABEL_URL, @name) + "?xt=#{State::READ}&#{query_str}"
        else
          sprintf(LABEL_URL, @name)
        end
        self.class.get_entries(url, :continuation => true)
      end
      
      private
        # Converts a hash to a query string but only keys that are valid
        def valid_keys_to_query_string(o)
          str = ''
          o.each { |k,v| str << "#{k}=#{v}&" if VALID_KEYS.include?(k) }
          str
        end
    end
  end
end