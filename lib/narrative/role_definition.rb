module Narrative
  module Context
    class RoleDefinition
      attr_reader :partners
      attr_reader :responsibilities

      def initialize(partners, &responsibilities)
        @partners = partners
        @responsibilities = responsibilities
      end

      def cast!(actor, casts)
        actor.instance_eval(&responsibilities)

        klass = class << actor; self end
        casts.slice(*partners).each do |role_name, partner|
          klass.instance_eval do
            define_method(role_name) { partner }
          end
        end

        actor
      end
    end
  end
end
