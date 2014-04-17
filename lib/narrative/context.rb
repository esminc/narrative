require 'active_support'

module Narrative
  module Context
    extend ActiveSupport::Concern

    included do
      cattr_reader(:roles) { {} }
    end

    module ClassMethods
      def role(name, &block)
        roles[name] = block

        define_method(name.to_sym) { @actors[name] }
      end
    end

    def initialize(data)
      validate!(data)

      @actors = {}

      cast! data
      introduce!
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
      roles.each do |role_name, method_block|
        data[role_name].instance_eval(&method_block)
        @actors[role_name] = data[role_name]
      end
    end

    def introduce!
      @actors.to_a.permutation(2).each do |(_, actor), (role_name, other)|
        actor.instance_variable_set "@#{role_name}", other

        actor.class.class_eval do
          attr_reader role_name
          private role_name
        end
      end
    end
  end
end
