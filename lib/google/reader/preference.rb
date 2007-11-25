module Google
  module Reader
    class Preference < Base
      @@greader_preferences = {}
      
      class << self
        # Returns a sorted list of all the available preference keys
        #
        # Usage:
        #   Google::Reader::Preference.available
        def available
          ensure_preferences_loaded
          @@greader_preferences.keys.sort
        end
        
        # Gives access to an individual preference. Replace any dash
        # in preference key with an underscore. (ie: mobile-num-entries 
        # is accessed using mobile_num_entries)
        #
        # Usage:
        #   Google::Reader::Preference[:design]
        #   Google::Reader::Preference[:mobile_use_transcoder]
        def [](pref)
          ensure_preferences_loaded
          @@greader_preferences[pref.to_s.gsub('_', '-')]
        end
        
        # Returns any preferences set for each feed and label. Not sure
        # what this could be helpful for so I'm not sure how to make things
        # easily accessible. Right now just returns straight up hash, not
        # very useful.
        def stream #:nodoc:
          parse_json(get(PREFERENCE_STREAM_URL))['streamprefs'].reject { |k,v| v == [] }
        end
        
        private
          # Gets all the preferences from google
          def load_all
            parse_json(get(PREFERENCE_URL))['prefs'].each do |p|
              @@greader_preferences[p['id']] = p['value']
            end
          end
          
          def ensure_preferences_loaded
            load_all if @@greader_preferences.keys.size == 0
          end
      end
    end
  end
end