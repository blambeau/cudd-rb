require 'spec_helper'
module Cudd
  describe Interface::BDD, 'or' do

    subject{ bdd_interface.or(x,y) }

    it_behaves_like "a BDD"

    it 'is equal to (x | y)' do
      subject.should eq(x | y)
    end

  end
end
