require 'active_support'

module Narrative
  module Context
    extend ActiveSupport::Concern

    included do
      cattr_accessor :roles, instance_accessor: false

      def self.role(name, &block)
        self.roles ||= {}
        roles[name] = block
      end

      def self.bind!(data, &block)
        block.call bind_roles!(data, &block)
      end

      private

      def self.bind_roles!(data, &block)
        context_roles = block.parameters.map(&:last)
        context_roles.each_with_object({}) {|role_name, actors|
          actors[role_name] = cast!(data[role_name], &roles[role_name])
        }
      end

      def self.cast!(datum, &method_block)
        datum.instance_eval(&method_block)
        datum
      end
    end
  end
end
