module Google
  module Reader    
    class Base < Base
      class << self        
        def parse(atom_feed)
          Atom::Feed.new(atom_feed)
        end
        
        def parse_json(json_str)
          JSON.parse(json_str)
        end
        
        def get_entries(url, o={})
          options = {:continuation => true,}.merge(o)
          body    = get(url)
          if options[:continuation]
            entries = parse(body).entries
            entries.class.class_eval "attr_accessor :continuation"
            entries.continuation = extract_continuation(body)
            entries
          else
            parse(body).entries
          end
        end
        
        # Gets a new token which can be used with all non-get requests.
        def get_token
          get(TOKEN_URL)
        end
        
        # Last time I checked this returns a hash like:
        #   {"isBloggerUser": true, "userId": "<user id number>", "userEmail": "nunemaker@gmail.com"}
        def user_info
          parse_json(get(USER_INFO_URL))
        end
        
        private
          # atom parser doesn't bring in google's custom atom fields
          # this method grabs the continuation so that i can instantly
          # grab the next set of items
          # <gr:continuation>CO3urYix4Y8C</gr:continuation>
          def extract_continuation(body)
            matches = body.match(/<gr:continuation>(.*)<\/gr:continuation>/)
            matches.nil? ? nil : matches[0].gsub(/<\/?gr:continuation>/, '')
          end
      end
    end
  end
end