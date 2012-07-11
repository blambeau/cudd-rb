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
    end

    it 'is not one' do
      subject.should_not be_one
    end

    it 'is not satisfiable and not a tautology' do
      subject.should_not be_satisfiable
      subject.should_not be_tautology
    end
  end
end
