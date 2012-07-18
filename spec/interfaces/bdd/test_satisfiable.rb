require 'spec_helper'
module Cudd
  describe Interface::BDD, 'satisfiable?' do

    subject{ bdd.satisfiable? }

    context 'on ZERO' do
      let(:bdd){ zero }
      it{ should be_false }
    end

    context 'on ONE' do
      let(:bdd){ one }
      it{ should be_true }
    end

    context 'on a variable' do
      let(:bdd){ x }
      it{ should be_true }
    end

    context 'on a satisfiable formula' do
      let(:bdd){ x & y }
      it{ should be_true }
    end

    context 'on a non satisfiable formula' do
      let(:bdd){ x & !x }
      it{ should be_false }
    end

  end
end
