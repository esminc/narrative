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
    end
  end
end
