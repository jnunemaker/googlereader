# This is getting the ids fine but I haven't figured out how 
# to post multiple elements of the same name yet in ruby so 
# don't use it unless you want to fix it.
require 'ostruct'
module Google #:nodoc:
  module Reader #:nodoc:
    class Search < Base #:nodoc:
      attr_accessor :q, :ids
      
      def initialize(q)
        self.q = q
        @executed = false
      end
      
      def execute
        response = self.class.get(SEARCH_IDS_URL, :query_hash => {
          :num => 1000, 
          :output => 'json', 
          :q => q
        })
        self.ids = self.class.parse_json(response)['results'].collect { |r| r['id'] }
        @executed = true
      end
      
      def results(o={})
        execute unless @executed
        options = {
          :token => nil,
          :start => 0,
          :num   => 20,
        }.merge(o)
        options[:token] ||= self.class.get_token
        
        if ids.size > 0
          raw_data  = ids[(options[:start]), options[:num]].collect { |id| "i=#{id}" unless id.nil? }.join('&')
          raw_data += "&T=#{options[:token]}"
          json_results = self.class.parse_json(self.class.post(SEARCH_CONTENTS_URL, :raw_data => raw_data))
          results = json_results['items'].inject([]) do |acc, r|
            result = OpenStruct.new(:google_id => r['id'], :title => r['title'], 
                                    :published => Time.at(r['published']), :author => r['author'], 
                                    :categories => r['categories'])
            if r['alternate'].size > 0
              result.alternate_href = r['alternate'].first['href']
              result.alternate_type = r['alternate'].first['type']
            end
            result.origin_title     = r['origin']['title']
            result.origin_url       = r['origin']['htmlUrl']
            result.origin_stream_id = r['origin']['streamId']
            result.content = r['content'] ? r['content']['content'] : ''
            acc << result
          end
          results.class.class_eval "attr_accessor :total"
          results.total = ids.size
          results
        else
          []
        end
      end
    end
  end
end