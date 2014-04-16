module Narrative
  module Context
    module Teller
      def with_context(context_name, data, &block)
        context_for(context_name).bind! data, block
      end

      private

      def context_for(name)
        name.split.map(&:capitalize).join.constantize
      end
    end
  end
end
