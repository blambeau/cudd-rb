require 'spec_helper'
module Cudd
  describe Interface::BDD, 'ith_var' do

    subject{ bdd_interface.ith_var(1) }

    it_behaves_like "a BDD"

    it 'has the correct index' do
      subject.var_index.should eq(1)
    end

    it 'is not one' do
      subject.should_not be_one
    end

    it 'is not zero' do
      subject.should_not be_zero
    end

    it 'is equal to itself' do
      subject.should eq(bdd_interface.ith_var(1))
    end

    it 'is not equal to another one' do
      subject.should_not eq(bdd_interface.ith_var(0))
    end

    it 'is satisfiable and not a tautology' do
      subject.should be_satisfiable
      subject.should_not be_tautology
    end
  end
end
