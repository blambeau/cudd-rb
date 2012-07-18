require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "each_sat" do

      subject{ formula.all_sat } # formula.each_sat.to_a

      before do
        formula.ref
      end

      after do
        subject.each do |sat|
          sat.should be_a(Assignment)
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
          subject.size.should eq(1)
          subject.first.to_hash.should eq({})
        end
      end

      context "on x" do
        let(:formula){ x }

        it 'yields one assignment with x=true' do
          subject.map(&:to_hash).should eq([{x => true}])
        end
      end

      context "on !x" do
        let(:formula){ !x }

        it 'yields one assignment with x=false' do
          subject.map(&:to_hash).should eq([{x => false}])
        end
      end

      context 'on (x & y)' do
        let(:formula){ x & y }

        it 'returns one assignment with both x and y to true' do
          subject.map(&:to_hash).should eq([{x => true, y => true}])
        end
      end

      context 'on (x | y)' do
        let(:formula){ x | y }

        it 'returns two assignments' do
          subject.sort.map(&:to_hash).should eq([{x => false, y => true}, {x => true}])
        end
      end

    end
  end
end 