require 'spec_helper'
module Cudd
  describe Interface::BDD, 'and' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      subject.deref
      interface.close if interface
    end

    subject{ interface.and(interface.new_var, interface.new_var) }

    it_behaves_like "a BDD"
  end
end