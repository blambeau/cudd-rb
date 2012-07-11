require 'spec_helper'
module Cudd
  describe Interface::BDD, 'or' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      subject.deref
      interface.close if interface
    end

    subject{ interface.or(interface.new_var, interface.new_var) }

    it_behaves_like "a BDD"
  end
end
