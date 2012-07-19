require 'spec_helper'
module Cudd
  describe Interface::BDD, 'new_vars' do

    context "with a number of variables" do
      subject{ bdd_interface.new_vars(5) }

      it 'returns an Array of 5 BDDs' do
        subject.should be_a(Array)
        subject.size.should eq(5)
        subject.each{|bdd| bdd.should be_a(Cudd::BDD) }
      end

      it 'returns 5 variables of different indexes' do
        start = bdd_interface.size
        subject.map(&:index).should eq((start...start+5).to_a)
      end
    end

    context 'with a single name' do
      subject{ bdd_interface.new_vars(:foo) }

      it 'returns an Array of 1 BDD with correct name' do
        subject.map(&:var_name).should eq([:foo])
      end
    end

    context 'with an array of names' do
      subject{ bdd_interface.new_vars([:foo, :bar]) }

      it 'returns an array of 2 BDDs with correct names' do
        subject.map(&:var_name).should eq([:foo, :bar])
      end
    end

    context 'with a varargs of names' do
      subject{ bdd_interface.new_vars(:foo, :bar) }

      it 'returns an array of 2 BDDs with correct names' do
        subject.map(&:var_name).should eq([:foo, :bar])
      end
    end

  end
end
