require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "each_sat" do

      subject{ formula.all_sat } # formula.each_sat.to_a

      before do
        x; y; z;
        formula.ref
      end

      after do
        subject.each do |sat|
          sat.should be_a(Array)
          formula.satisfied?(sat).should be_true
        end
        formula.deref if formula
      end

      context 'without a block' do
        let(:formula){ x & y }

        it 'returns an enumerator' do
          formula.each_sat.should be_a(Enumerator)
        end
      end

      context "on ZERO" do
        let(:formula){ zero }

        it 'yields no assignment' do
          subject.should be_empty
        end
      end

      context "on ONE" do
        let(:formula){ one }

        it 'yields one empty assignment' do
          subject.should eq([[2,2,2]])
        end
      end

      context "on x" do
        let(:formula){ x }

        it 'yields one assignment with x=true' do
          subject.should eq([[1,2,2]])
        end
      end

      context "on !x" do
        let(:formula){ !x }

        it 'yields one assignment with x=false' do
          subject.should eq([[0,2,2]])
        end
      end

      context 'on (x & y)' do
        let(:formula){ x & y }

        it 'returns one assignment with both x and y to true' do
          subject.should eq([[1,1,2]])
        end
      end

      context 'on (x | y)' do
        let(:formula){ x | y }

        it 'returns two assignments' do
          subject.should eq([[0,1,2], [1,2,2]])
        end
      end

    end
  end
end 