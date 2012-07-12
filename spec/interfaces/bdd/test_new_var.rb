require 'spec_helper'
module Cudd
  describe Interface::BDD, 'new_var' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      interface.close if interface
    end

    subject{ interface.new_var }

    it_behaves_like "a BDD"

    it 'is not one' do
      subject.should_not be_one
    end

    it 'is not zero' do
      subject.should_not be_zero
    end

    it 'is not equal to another one' do
      subject.should_not eq(interface.new_var)
    end

    it 'is satisfiable and not a tautology' do
      subject.should be_satisfiable
      subject.should_not be_tautology
    end
  end
end
