require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "assignment" do

      shared_examples_for "A x=0, y=1, z=2 assignment" do
        it 'is an assignment' do
          subject.should be_a(Assignment)
        end
        
        it 'to_a returns [1, 0, 2]' do
          subject.to_a.should eq([1, 0, 2])
        end

        it 'to_hash returns {x => true, y => false}' do
          subject.to_hash.should eq(x => true, y => false)
        end
      end

      before do
        x; y; z
      end

      subject{ bdd_interface.assignment(*args) }

      context 'with an array of Integers' do
        let(:args){ [ [1, 0, 2] ] }

        it_behaves_like "A x=0, y=1, z=2 assignment"
      end

      context 'with a Hash mapping BDD variables to truth values' do
        let(:args){ [ {x => 1, y => 0} ] }
      
        it_behaves_like "A x=0, y=1, z=2 assignment"
      end

    end
  end # module Interfaces
end # module Cudd