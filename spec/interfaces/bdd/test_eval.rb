require 'spec_helper'
module Cudd
  describe Interface::BDD, 'eval' do

    let(:interface){ Cudd.manager.interface(:BDD) }

    after do
      interface.close if interface
    end

    let(:x){ interface.new_var }
    let(:y){ interface.new_var }

    subject{ interface.eval(formula, input) }

    context 'on one' do
      let(:formula){ interface.one }
      let(:input){ [] }
      it 'is always satisfied' do
        subject.should eq(interface.one)
      end
    end
    
    context 'on zero' do
      let(:formula){ interface.zero }
      let(:input){ [] }
      it 'is never satisfied' do
        subject.should eq(interface.zero)
      end
    end
    
    context 'on (x & y) with satisfying input' do
      let(:formula){ interface.and(x, y) }
      let(:input){ [ 1, 1 ] }
      it 'is satisfied' do
        subject.should eq(interface.one)
      end
    end

    context 'on (x & y) with non satisfying input' do
      let(:formula){ interface.and(x, y) }
      let(:input){ [ 1, 0 ] }
      it 'is not satisfied' do
        subject.should eq(interface.zero)
      end
    end

    context 'on invalid input' do
      let(:input){ [ ] }
      
      it 'complements input with missing 0' do
        interface.eval(x, input).should eq(interface.zero)
        interface.eval(!x, input).should eq(interface.one)
      end
    end

    it 'is accessible as BDD#eval' do
      (x & y).eval([1, 1]).should eq(interface.one)
      (x & y).eval([1, 0]).should eq(interface.zero)
    end

  end
end
