module Google
  module Reader
    class Preference < Base
      @@greader_preferences = {}
      
      class << self
        def load_all
          parse_json(get(PREFERENCE_URL))['prefs'].each do |p|
            @@greader_preferences[p['id']] = p['value']
          end
        end
        
        def available
          ensure_preferences_loaded
          @@greader_preferences.keys.sort
        end
        
        def [](pref)
          ensure_preferences_loaded
          @@greader_preferences[pref.to_s.gsub('_', '-')]
        end
        
        private
          def ensure_preferences_loaded
            load_all if @@greader_preferences.keys.size == 0
          end
      end
    end
  end
end

# {
#  "prefs": [
#   {
#    "id": "start-page",
#    "value": "user/00216996281641687092/label/ruby-on-rails"
#   },
#   {
#    "id": "is-legacy-ui-user",
#    "value": "true"
#   },
#   {
#    "id": "show-scour-help-go-off",
#    "value": "false"
#   },
#   {
#    "id": "animations-disabled",
#    "value": "false"
#   },
#   {
#    "id": "show-all-tree-items",
#    "value": "false"
#   },
#   {
#    "id": "shuffle-token",
#    "value": "228686173662293195"
#   },
#   {
#    "id": "show-oldest-interrupt",
#    "value": "true"
#   },
#   {
#    "id": "show-scroll-help",
#    "value": "false"
#   },
#   {
#    "id": "show-scour-help-go-on",
#    "value": "false"
#   },
#   {
#    "id": "is-card-view",
#    "value": "true"
#   },
#   {
#    "id": "scroll-tracking-enabled",
#    "value": "true"
#   },
#   {
#    "id": "read-items-visible",
#    "value": "false"
#   },
#   {
#    "id": "is-in-scour-mode",
#    "value": "false"
#   },
#   {
#    "id": "mobile-use-transcoder",
#    "value": "true"
#   },
#   {
#    "id": "queue-sorting",
#    "value": "date"
#   },
#   {
#    "id": "design",
#    "value": "scroll"
#   },
#   {
#    "id": "show-min-navigation-help",
#    "value": "true"
#   },
#   {
#    "id": "display-lang",
#    "value": ""
#   },
#   {
#    "id": "mobile-num-entries",
#    "value": "9"
#   },
#   {
#    "id": "show-minimized-navigation",
#    "value": "false"
#   }
#  ]
# }
