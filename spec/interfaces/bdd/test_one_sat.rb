require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "one_sat" do

      subject{ formula.one_sat }

      before do
        formula.ref
      end

      after do
        formula.deref if formula
      end

      context 'on (x & y)' do
        let(:formula){ x & y }
      
        it 'returns an assignment x => true & y => true' do
          subject.should eq(cube(x => true, y => true))
        end
      end
      
      context 'on (x | y)' do
        let(:formula){ x | y }
      
        it 'returns a bdd satisfied by x => true' do
          subject.should eq(cube(x => true))
        end
      end

    end
  end
end