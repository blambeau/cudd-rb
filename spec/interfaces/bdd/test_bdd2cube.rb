require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "bdd2cube" do

      before do
        x; y; z
      end

      subject{ bdd_interface.bdd2cube(x & !y) }

      it 'returns an Array' do
        subject.should be_a(Array)
      end

      it 'encodes missing variables as well as explicit ones' do
        subject.should eq([1, 0, 2])
      end

      it 'is available as BDD#to_cube' do
        (x & !y).to_cube.should eq(subject)
      end

      it 'raises a NotACubeError on a BDD that is not a cube' do
        lambda{
          (x | y).to_cube
        }.should raise_error(NotACubeError)
      end

    end
  end
end
