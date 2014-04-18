module Narrative
  module Context
    class RoleDefinition
      attr_reader :name

      def initialize(name, partners, &responsibilities)
        @name = name
        @partners = partners
        @responsibilities = responsibilities
      end

      def cast!(data)
        actor = data[@name]
        actor.instance_eval(&@responsibilities)

        klass = class << actor; self end
        data.slice(*@partners).each do |role_name, partner|
          klass.instance_eval do
            define_method(role_name) { partner }
          end
        end

        actor
      end
    end
  end
end
