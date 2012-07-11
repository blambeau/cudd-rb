require 'spec_helper'
module Cudd
  describe Interface::BDD, 'not' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      subject.deref
      interface.close if interface
    end

    let(:x){ interface.new_var }
    subject{ interface.not(x) }

    it_behaves_like "a BDD"

    it 'yields its origin if negated' do
      interface.not(subject).should eq(x)
    end
  end
end