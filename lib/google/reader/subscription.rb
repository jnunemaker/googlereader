require 'ostruct'
module Google
  module Reader
    class Subscription < Base      
      class << self
        def all
          parse_json(get(SUBSCRIPTION_LIST_URL))['subscriptions'].inject([]) do |subs, s|
            subs << OpenStruct.new( :firstitemmsec => s['firstitemmsec'], 
                                    :title         => s['title'], 
                                    :google_id     => s['id'],
                                    :categories    => s['categories'].inject([]) { |cats, c| cats << OpenStruct.new(:google_id => c['id'], :name => c['label']) })
          end
        end
      end
    end
  end
end