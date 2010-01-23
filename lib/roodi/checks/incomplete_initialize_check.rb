require 'roodi/checks/check'

module Roodi
  module Checks
    # Checks a class initialize method to make sure it has a call to the base class initialize method.
    # 
    # Keeping to a consistent nameing convention makes your code easier to read.
    class IncompleteInitializeCheck < Check
      def interesting_nodes
        [:class, :defn]
      end

      def evaluate_start_class(node)
		@is_derived_class =  (node[0] == :class and node[2] and node[2].node_type == :const)
		@class_name = node[1].class == Symbol ? node[1] : node[1].last
      end

      def evaluate_start_defn(node)
		if @is_derived_class and node[1].to_s == "initialize"
			add_error("The class #{@class_name} has not invoked the initialize method of its base class.") unless has_super_statement?(node.children[1])
		end
      end

	  private

      def has_super_statement?(node)
        false unless node
        node.node_type == :super or node.node_type == :zsuper or node.children.any? { |child| has_super_statement?(child) } if node
      end

    end
  end
end
