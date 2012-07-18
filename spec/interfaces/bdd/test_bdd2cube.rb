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

    end
  end
end
