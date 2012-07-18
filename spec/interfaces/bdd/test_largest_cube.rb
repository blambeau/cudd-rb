require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "largest_cube" do

      subject{ formula.largest_cube }

      before do
        formula.ref
      end

      after do
        (subject.each_sat.to_a.size <= 1).should be_true
        formula.deref if formula
      end

      context "on ZERO" do
        let(:formula){ zero }

        it 'returns ZERO' do
          subject.should be_zero
        end
      end

      context "on ONE when no variables" do
        let(:formula){ one }

        it 'returns ONE' do
          subject.should eq(one)
        end
      end

      context "on x" do
        let(:formula){ x }
      
        it 'yields a bdd that has x => true as unique assignment' do
          subject.each_sat.first.should eq(assignment(x => true))
        end
      end
      
      context "on !x" do
        let(:formula){ !x }
      
        it 'yields a bdd that has x => false as unique assignment' do
          subject.each_sat.first.should eq(assignment(x => false))
        end
      end
      
      context 'on (x & y)' do
        let(:formula){ x & y }
      
        it 'returns a bdd satisfied by x => true & y => true' do
          subject.each_sat.first.should eq(assignment(x => true, y => true))
        end
      end
      
      context 'on (x | y)' do
        let(:formula){ x | y }
      
        it 'returns a bdd satisfied by x => true' do
          subject.each_sat.first.should eq(assignment(x => true))
        end
      end

      context 'on (x & y) | z' do
        let(:formula){ (x & y) | z }
      
        it 'returns a bdd satisfied by x => true, y => true' do
          subject.each_sat.first.should eq(assignment(x => true, y => true))
        end
      end

    end
  end
end