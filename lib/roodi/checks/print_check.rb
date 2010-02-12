require 'roodi/checks/check'

module Roodi
  module Checks
    # Checks for print statements.
    # 
    # Left over print statements from a debugging session could cause problems in production
    class PrintCheck < Check
	  DEFAULT_FUNCTIONS = 'p,puts'
      def initialize(options = {})
	    super()
        @functions = (options['functions'] || DEFAULT_FUNCTIONS).split(',')
	  end

      def interesting_nodes
        [:call]
      end

      def evaluate_start_call(node)
		if @functions.include? node[2].to_s
        	add_error "#{node[2]} statement found." 
		end
      end
    end
  end
end
