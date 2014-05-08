require 'spec_helper'

describe Narrative::Context::Teller do
  describe '#with_context' do
    class RefactorContext
      include Narrative::Context

      principal :programmer do
        def refactor!(code)
          code.thrown_away!
        end
      end
    end

    class ContextConsumer
      include Narrative::Context::Teller

      attr_accessor :code

      def initialize(code)
        self.code = code
      end

      def consume
        with_context 'refactor', programmer: 'alice' do |programmer|
          programmer.refactor! code
        end
      end
    end

    specify do
      code = double('code')
      allow(code).to receive(:thrown_away!)

      ContextConsumer.new(code).consume

      expect(code).to have_received(:thrown_away!).once
    end
  end
end
