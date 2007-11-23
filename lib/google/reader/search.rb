# This is getting the ids fine but I haven't figured out how 
# to post multiple elements of the same name yet in ruby so 
# don't use it unless you want to fix it.
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
        options = {
          :token => nil,
          :start => 0,
          :num   => 20,
        }.merge(o)
        
        options[:token] ||= self.class.get_token
        
        if ids.size > 0
          i_str = ids[options[:start]] + '&'
          i_str += ids[(options[:start]+1)..options[:num]].collect { |id| ["i=#{id}&"] unless id.nil? }.join('')
          
          self.class.post(SEARCH_CONTENTS_URL, :form_data => {
            :T => options[:token],
            :i => i_str,
          })
        end
      end
    end
  end
end