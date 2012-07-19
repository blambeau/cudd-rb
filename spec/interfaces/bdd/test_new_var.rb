require 'spec_helper'
module Cudd
  describe Interface::BDD, 'new_var' do

    context 'without argument' do
      subject{ bdd_interface.new_var }

      it_behaves_like "a BDD"

      it 'has the last index' do
        next_index = bdd_interface.size
        subject.var_index.should eq(next_index)
      end

      it 'has a default name' do
        subject.var_name.should eq(:"v#{subject.var_index}")
      end
    end

    context 'with a name as argument' do
      subject{ bdd_interface.new_var(:foo) }

      it_behaves_like "a BDD"

      it 'has the last index' do
        next_index = bdd_interface.size
        subject.var_index.should eq(next_index)
      end

      it 'has the provided name' do
        subject.var_name.should eq(:foo)
      end
    end

  end
end
