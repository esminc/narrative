require 'active_support/core_ext/string/inflections'

module Narrative
  module Context
    module Teller
      def with_context(context_name, data, &block)
        context_for(context_name).bind! data, &block
      end

      private

      def context_for(name)
        context_names = name.split << 'context'
        context_names.map(&:capitalize).join.constantize
      end
    end
  end
end
