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

  describe 'cast roles to data' do
    class ProjectContext
      include Narrative::Context

      role :programmer do
        def coding; end
      end

      role :tester do
        def report_bug; end
      end
    end

    let(:data) { {programmer: 'alice', tester: 'bob' } }

    subject { ProjectContext.new(data) }

    context 'programmer alice and tester bob' do
      it { is_expected.to respond_to(:programmer) }
      it { is_expected.to respond_to(:tester) }
    end

    context 'tester is require but absent' do
      let(:data) { {programmer: 'alice', tester: nil} }

      it { expect { ProjectContext.new(data) }.to raise_error }
    end

    context 'excessive role' do
      let(:data) { {programmer: 'alice', tester: 'bob', product_owner: 'charlie'} }

      it { expect { ProjectContext.new(data) }.to raise_error }
    end
  end

  describe 'can refer to other roles' do
    class BugfixContext
      include Narrative::Context

      role :programmer do
        def correct!(code)
          code.modified!
        end
      end

      role :tester, partners: [:programmer] do
        def report_bug(code)
          programmer.correct!(code)
        end
      end
    end

    specify do
      code = double('defected code')
      allow(code).to receive(:modified!)

      BugfixContext.new(programmer: 'alice', tester: 'bob').perform do |programmer:, tester:|
        tester.report_bug(code)
      end

      expect(code).to have_received(:modified!).once
    end
  end

  describe '#perform' do
    class ProjectContext
      include Narrative::Context

      role :programmer do
        def coding; end
      end

      role :tester do
        def report_bug; end
      end
    end

    specify do
      called = false
      context = ProjectContext.new({programmer: 'alice', tester: 'bob'})

      context.perform do |programmer:, tester:|
        expect(programmer).to eq(context.programmer)
        expect(tester).to eq(context.tester)

        called = true
      end

      expect(called).to eq(true)
    end
  end
end
