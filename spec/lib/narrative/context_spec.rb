require 'spec_helper'

describe Narrative::Context do
  describe '.role' do
    class ProjectContext
      include Narrative::Context

      role :programmer do; end
    end

    class AnotherProjectContext
      include Narrative::Context

      role :product_owner do; end
    end

    it { expect(ProjectContext.roles).to include(:programmer) }
    it { expect(ProjectContext.roles).not_to include(:product_owner) }
  end

  describe '.bind' do
    class ProjectContext
      include Narrative::Context

      role :programmer do
        def coding; end
      end
    end

    specify do
      called = false
      ProjectContext.bind! programmer: 'alice' do |programmer:|
        expect(programmer).to respond_to(:coding)

        called = true
      end

      expect(called).to eq(true)
    end
  end
end
