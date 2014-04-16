module Narrative
  module Context
    module Blender
      def with_context(context_name, attributes, &block)
        context_for(context_name).bind! attributes, block
      end

      private

      def context_for(name)
        name.split.map(&:capitalize).join.constantize
      end
    end
  end
end
