require 'spec_helper'
module Cudd
  describe Interface::BDD, 'zero' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      subject.deref
      interface.close if interface
    end

    subject{ interface.zero }

    it_behaves_like "a BDD"

    it 'is zero' do
      subject.should be_zero
      subject.should be_contradiction
      subject.false?.should eq(true)
    end

    it 'is not one' do
      subject.should_not be_one
      subject.true?.should eq(false)
      subject.should_not be_tautology
    end

    it 'is not satisfiable' do
      subject.should_not be_satisfiable
    end
  end
end
