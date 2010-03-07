require 'roodi/checks/check'

module Roodi
  module Checks
    # Checks for classes that have implemented method_missing but have not implementes responds_to?
    # 
    # When you've changed your class with method_missing, it's good practice to change responds_to? as well so that 
	# your class will appear consistent to other code that uses your class and uses responds_to? to find if a certain method call is handled.
    class MissingRespondsToCheck < Check
      def interesting_nodes
        [:defn, :class]
      end

      def evaluate_start_defn(node)
		if node[1].to_s == "method_missing"
        	@method_missing_implemented = true
		end
		if node[1].to_s == "responds_to?"
        	@responds_to_implemented= true
		end
      end

      def evaluate_start_class(node)
        @method_missing_implemented = false
        @responds_to_implemented = false
		@class_name = node[1].class == Symbol ? node[1] : node[1].last
      end

      def evaluate_end_class(node)
	  	if @method_missing_implemented and !@responds_to_implemented
        	add_error "#{@class_name} implemented method_missing but did not implement responds_to? ." 
		end
      end
    end
  end
end
