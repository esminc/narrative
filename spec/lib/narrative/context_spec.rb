require 'spec_helper'

describe Narrative::Context do
  class ProjectContext
    include Narrative::Context

    principal :programmer do
      def coding; end
    end

    role :tester do
      def report_bug; end
    end
  end

  describe '.role' do
    class AnotherProjectContext
      include Narrative::Context

      principal :product_owner do; end
    end

    subject { ProjectContext.roles.map(&:name) }

    it { is_expected.to include(:programmer) }
    it { is_expected.not_to include(:product_owner) }
  end

  describe 'cast roles to data' do
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
          add_unit_test_for code
          code.modified!
        end

        private

        def add_unit_test_for(code); end
      end

      principal :tester, partners: [:programmer] do
        def report_bug(code)
          programmer.correct!(code)
        end
      end
    end

    specify do
      code = double('defected code')
      allow(code).to receive(:modified!)

      BugfixContext.new(programmer: 'alice', tester: 'bob').perform do |tester|
        tester.report_bug(code)
      end

      expect(code).to have_received(:modified!).once
    end
  end

  describe '#perform' do
    specify do
      called = false
      alice = 'alice'
      context = ProjectContext.new({programmer: alice, tester: 'bob'})

      context.perform do |programmer|
        expect(programmer).to be(alice)

        called = true
      end

      expect(called).to eq(true)
    end
  end
end
