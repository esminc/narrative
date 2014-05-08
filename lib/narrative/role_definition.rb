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
        role = Module.new(&@responsibilities)
        acquaint! role, actors.slice(*@partners)

        actors[@name].extend(role)
      end

      private

      def acquaint!(role_module, partners)
        role_module.instance_eval do
          partners.each do |role_name, partner|
            define_method(role_name) { partner }
            private role_name
          end
        end
      end
    end
  end
end
