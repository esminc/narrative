require 'active_support'
require_relative 'role_definition'

module Narrative
  module Context
    extend ActiveSupport::Concern

    included do
      private(*cattr_accessor(:roles) { [] })
    end

    module ClassMethods
      def role(name, partners: [], &block)
        roles << RoleDefinition.new(name, partners, &block)
        define_method(name.to_sym) { @actors[name] }
      end
    end

    def initialize(data)
      validate!(data)

      @actors = cast!(data)
    end

    def perform(&block)
      block.call @actors.slice(*block.parameters.map(&:last))
    end

    private

    def validate!(data)
      raise 'data and role definition did not same' if data.keys.to_set != roles.map(&:name).to_set
      raise 'data did not allow to contain nil' if data.values.include?(nil)
    end

    def cast!(data)
      roles.each_with_object({}) do |role_definition, memo|
        memo[role_definition.name] = role_definition.cast!(data)
      end
    end
  end
end
