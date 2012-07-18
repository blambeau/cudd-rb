require 'spec_helper'
module Cudd
  describe Interface::BDD, 'satisfied?' do

    let(:assignment){ { x => true, y => false } }

    subject{ bdd.satisfied?(assignment) }

    context 'on ZERO' do
      let(:bdd){ zero }
      it{ should be_false }
    end

    context 'on ONE' do
      let(:bdd){ one }
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
      let(:bdd){ x & y }
      it{ should be_false }
    end

    context 'on a satisfied formula' do
      let(:bdd){ x | y }
      it{ should be_true }
    end

  end
end
