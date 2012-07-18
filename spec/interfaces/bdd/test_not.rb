require 'spec_helper'
module Cudd
  describe Interface::BDD, 'not' do

    subject{ bdd_interface.not(x) }

    it_behaves_like "a BDD"

    it 'yields its origin if negated' do
      bdd_interface.not(subject).should eq(x)
    end

    it 'is equal to !x' do
      subject.should eq(!x)
    end

  end
end
