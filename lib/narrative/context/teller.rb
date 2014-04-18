require 'active_support/core_ext/string/inflections'

module Narrative
  module Context
    module Teller
      def with_context(context_name, data, &block)
        context_for(context_name, data).perform(&block)
      end

      private

      def context_for(name, data)
        context_names = name.split << 'context'
        context_class = context_names.map(&:capitalize).join.constantize
        context_class.new(data)
      end
    end
  end
end
