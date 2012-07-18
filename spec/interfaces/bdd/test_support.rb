require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "support" do

      subject{ formula.support }

      before do
        formula.ref
      end

      after do
        formula.deref if formula
      end

      context "on ZERO" do
        let(:formula){ zero }

        it 'returns ONE' do
          subject.should eq(one)
        end
      end

      context "on ONE" do
        let(:formula){ one }

        it 'returns ONE' do
          subject.should eq(one)
        end
      end

      context "on x" do
        let(:formula){ x }

        it 'returns x' do
          subject.should eq(x)
        end
      end

      context "on !x" do
        let(:formula){ !x }

        it 'returns x' do
          subject.should eq(x)
        end
      end

      context 'on (x & y)' do
        let(:formula){ x & y }

        it 'returns x & y' do
          subject.should eq(x & y)
        end
      end

      context 'on (x | !y)' do
        let(:formula){ x | !y }

        it 'returns x & y' do
          subject.should eq(x & y)
        end
      end

    end
  end
end