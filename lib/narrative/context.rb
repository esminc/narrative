require 'active_support'
require_relative 'role_definition'

module Narrative
  module Context
    extend ActiveSupport::Concern

    included do
      cattr_reader(:roles) { {} }
    end

    module ClassMethods
      def role(name, partners: [], &block)
        roles[name] = RoleDefinition.new(partners, &block)
        define_method(name.to_sym) { @actors[name] }
      end
    end

    def initialize(data)
      validate!(data)

      @actors = {}

      cast! data
    end

    def perform(&block)
      block.call @actors.slice(*block.parameters.map(&:last))
    end

    private

    def validate!(data)
      raise 'data and role definition did not same' if data.keys.to_set != roles.keys.to_set
      raise 'data did not allow to contain nil' if data.values.include?(nil)
    end

    def cast!(data)
      roles.each do |role_name, role_definition|
        @actors[role_name] = role_definition.cast!(data[role_name], data.except(role_name))
      end
    end
  end
end
