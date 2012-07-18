require 'spec_helper'
module Cudd
  describe Interface::BDD, 'one' do

    subject{ one }

    it_behaves_like "a BDD"

    it 'is one' do
      subject.should be_one
      subject.true?.should eq(true)
      subject.should be_tautology
    end

    it 'is not zero' do
      subject.should_not be_zero
      subject.should_not be_contradiction
      subject.false?.should eq(false)
    end

    it 'is satisfiable' do
      subject.should be_satisfiable
    end

  end
end
