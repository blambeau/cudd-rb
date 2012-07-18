require 'spec_helper'
module Cudd
  describe Interface::BDD, 'satisfiable?' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      interface.close if interface
    end

    subject{ bdd.satisfiable? }

    context 'on ZERO' do
      let(:bdd){ interface.zero }
      it{ should be_false }
    end

    context 'on ONE' do
      let(:bdd){ interface.one }
      it{ should be_true }
    end

    context 'on a variable' do
      let(:bdd){ interface.new_var }
      it{ should be_true }
    end

    context 'on a satisfiable formula' do
      let(:bdd){ interface.and(interface.new_var, interface.new_var) }
      it{ should be_true }
    end

    context 'on a non satisfiable formula' do
      let(:bdd){ x = interface.new_var; interface.and(x, !x) }
      it{ should be_false }
    end

  end
end
