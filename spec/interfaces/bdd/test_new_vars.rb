require 'spec_helper'
module Cudd
  describe Interface::BDD, 'new_vars' do

    subject{ bdd_interface.new_vars(arg) }

    context "with a number of variables" do
      let(:arg){ 5 }

      it 'returns an Array of 5 BDDs' do
        subject.should be_a(Array)
        subject.size.should eq(5)
        subject.each{|bdd| bdd.should be_a(Cudd::BDD) }
      end

      it 'returns 5 variables of different indexes' do
        start = bdd_interface.size
        subject.map(&:index).should eq((start...start+arg).to_a)
      end
    end

  end
end
