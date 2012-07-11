require 'spec_helper'
module Cudd
  describe Interface::BDD, 'one' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      subject.deref
      interface.close if interface
    end

    subject{ interface.one }

    it_behaves_like "a BDD"

    it 'is one' do
      subject.should be_one
    end

    it 'is not zero' do
      subject.should_not be_zero
    end

    it 'is satisfiable and a tautology' do
      subject.should be_satisfiable
      subject.should be_tautology
    end
  end
end
