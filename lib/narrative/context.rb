require 'active_support'

module Narrative
  module Context
    extend ActiveSupport::Concern

    included do
      cattr_reader(:roles, instance_accessor: false) { {} }
    end

    module ClassMethods
      def role(name, &block)
        roles[name] = block
      end

      def bind!(data, &block)
        block.call bind_roles!(data, &block)
      end

      private

      def bind_roles!(data, &block)
        context_roles = block.parameters.map(&:last)
        context_roles.each_with_object({}) {|role_name, actors|
          actors[role_name] = cast!(data[role_name], &roles[role_name])
        }
      end

      def cast!(datum, &method_block)
        datum.instance_eval(&method_block)
        datum
      end
    end
  end
end
