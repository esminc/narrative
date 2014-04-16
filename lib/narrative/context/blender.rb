module Narrative
  module Context
    module Blender
      def with_context(context_name, attributes, &block)
        context = context_for(context_name).new(attributes)
        context.bind block
      end

      private

      def context_for(name)
        name.split.map(&:capitalize).join.constantize
      end
    end
  end
end
