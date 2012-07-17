require 'spec_helper'
module Cudd
  describe Assignment, "to_a" do

    let(:interface){ Cudd.manager(:numVars => 2).interface(:BDD) }
    let(:x){ interface.ith_var(0) }
    let(:y){ interface.ith_var(1) }

    subject{ Assignment.new(interface, input).to_a }

    context 'when built with an array of integers' do
      let(:input){ [1, 0] }

      it 'uses that input' do
        subject.should eq([1, 0])
      end 
    end

    context 'when built with an incomplete array of integers' do
      let(:input){ [1] }

      it 'uses 2 for missing variables' do
        subject.should eq([1, 2])
      end 
    end

    context 'when built with an array of booleans' do
      let(:input){ [true, false] }

      it 'uses that input' do
        subject.should eq([1, 0])
      end 
    end

    context 'when built with a Hash of BDDs' do
      let(:input){ {x => true, y => false} }

      it 'uses that input' do
        subject.should eq([1, 0])
      end 
    end

    context 'when built with an incomplete Hash of BDDs' do
      let(:input){ {x => true} }

      it 'uses 2 for missing variables' do
        subject.should eq([1, 2])
      end 
    end

  end
end