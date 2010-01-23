require 'roodi/checks/check'

module Roodi
  module Checks
    # Checks for duplicate test names
    # 
    # Having duplicate test names means some of the tests are not running!!
    class DuplicateTestsCheck < Check
      def interesting_nodes
        [:defn, :class]
      end

      def evaluate_start_defn(node)
		if node[1].to_s =~ /test_*/
			if @method_names.include? node[1]
        		add_error "Duplicate test #{node[1]} found in #{@class_name}." 
			else
	  			@method_names << node[1] 
			end
		end
      end

      def evaluate_start_class(node)
        @method_names = []
		@class_name = node[1].class == Symbol ? node[1] : node[1].last
      end
    end
  end
end
