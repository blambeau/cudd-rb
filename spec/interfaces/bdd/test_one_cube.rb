require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "one_cube" do

      subject{ formula.one_cube }

      before do
        formula.ref
        subject.should be_a(Cube)
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
      
        it 'returns a bdd satisfied by x => false, y => true' do
          subject.should eq(cube(x => false, y => true))
        end
      end

    end
  end
end