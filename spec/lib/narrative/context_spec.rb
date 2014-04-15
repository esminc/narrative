require 'spec_helper'

describe Narrative::Context do
  describe '.role' do
    class ProjectContext
      include Narrative::Context

      role :programmer do
        def coding; end
      end
    end

    class AnotherProjectContext
      include Narrative::Context

      role :product_owner do
        def accept_story; end
      end
    end

    it { expect(ProjectContext.roles).to include(:programmer) }
    it { expect(ProjectContext.roles).not_to include(:product_owner) }
  end
end
