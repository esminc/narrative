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

      bind_roles! data
    end

    def perform(&block)
      block.call @actors.slice(*block.parameters.map(&:last))
    end

    private

    def validate!(data)
      raise 'data and role definition did not same' if data.keys.to_set != roles.keys.to_set
      raise 'data did not allow to contain nil' if data.values.include?(nil)
    end

    def bind_roles!(data)
      roles.each do |role_name, method_block|
        @actors[role_name] = cast!(data[role_name], method_block)
      end
    end

    def cast!(datum, method_block)
      datum.instance_eval(&method_block)
      datum
    end
  end
end
