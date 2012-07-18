require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "cube2bdd" do

      before do
        x; y; z
      end

      subject{ bdd_interface.cube2bdd([1, 0, 2]) }

      it 'returns a BDD' do
        subject.should be_a(Cudd::BDD)
      end

      it 'support 1, 0 and 2' do
        subject.should eq(x & !y)
      end

    end
  end
end
