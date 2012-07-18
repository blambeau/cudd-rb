require 'spec_helper'
module Cudd
  describe Interface::BDD, 'and' do

    subject{ bdd_interface.and(x,y) }

    it_behaves_like "a BDD"

    it 'is equal to (x & y)' do
      subject.should eq(x & y)
    end

  end
end
