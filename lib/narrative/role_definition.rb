module Narrative
  module Context
    class RoleDefinition
      attr_reader :name

      def initialize(name, partners, &responsibilities)
        @name = name
        @partners = partners
        @responsibilities = responsibilities
      end

      def cast!(actors)
        actor = actor!(actors)
        relationship!(actor, actors)

        actor
      end

      private

      def actor!(actors)
        actor = actors[@name]
        actor.instance_eval(&@responsibilities)
        actor
      end

      def relationship!(actor, actors)
        klass = class << actor; self end
        actors.slice(*@partners).each do |role_name, partner|
          klass.instance_eval do
            define_method(role_name) { partner }
          end
        end
      end
    end
  end
end
