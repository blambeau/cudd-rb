require 'spec_helper'
module Cudd
  describe Interface::BDD, 'satisfied?' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      interface.close if interface
    end

    let(:x){ interface.new_var }
    let(:y){ interface.new_var }
    let(:assignment){ { x => true, y => false } }
    subject{ x; y; bdd.satisfied?(assignment) }

    context 'on ZERO' do
      let(:bdd){ interface.zero }
      it{ should be_false }
    end

    context 'on ONE' do
      let(:bdd){ interface.one }
      it{ should be_true }
    end

    context 'on the variable x' do
      let(:bdd){ x }
      it{ should be_true }
    end

    context 'on the variable y' do
      let(:bdd){ y }
      it{ should be_false }
    end

    context 'on a non satisfied formula' do
      let(:bdd){ interface.and(x, y) }
      it{ should be_false }
    end

    context 'on a satisfied formula' do
      let(:bdd){ interface.or(x, y) }
      it{ should be_true }
    end

  end
end
