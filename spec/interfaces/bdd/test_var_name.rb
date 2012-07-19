require 'spec_helper'
module Cudd
  describe Interface::BDD, 'var_name' do

    subject{ bdd_interface.var_name(bdd) }

    context 'on zero' do
      let(:bdd){ zero }

      it{ should eq(:zero) }
    end

    context 'on one' do
      let(:bdd){ one }

      it{ should eq(:one) }
    end

    context 'on an unnamed variable' do
      let(:bdd){ x }
      
      it { should eq(:v0) }
    end

    context 'on an named variable' do
      let(:bdd){ bdd_interface.new_var(:foo) }
      
      it { should eq(:foo) }
    end

  end
end
