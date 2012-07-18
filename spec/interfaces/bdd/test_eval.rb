require 'spec_helper'
module Cudd
  describe Interface::BDD, 'eval' do

    subject{ bdd_interface.eval(formula, input) }

    context 'on one' do
      let(:formula){ one }
      let(:input){ [] }

      it 'is always satisfied' do
        subject.should eq(one)
      end
    end
    
    context 'on zero' do
      let(:formula){ zero }
      let(:input){ [] }

      it 'is never satisfied' do
        subject.should eq(zero)
      end
    end
    
    context 'on (x & y) with satisfying input' do
      let(:formula){ bdd_interface.and(x, y) }
      let(:input){ [ 1, 1 ] }

      it 'is satisfied' do
        subject.should eq(one)
      end
    end

    context 'on (x & y) with non satisfying input' do
      let(:formula){ bdd_interface.and(x, y) }
      let(:input){ [ 1, 0 ] }

      it 'is not satisfied' do
        subject.should eq(zero)
      end
    end

    context 'on a non-satisfying Hash input' do
      let(:formula){ bdd_interface.and(x, y) }
      let(:input){ {x => 1, y => 0} }

      it 'is not satisfied' do
        subject.should eq(zero)
      end
    end

    context 'on a satisfying Hash input' do
      let(:formula){ bdd_interface.and(x, y) }
      let(:input){ {x => 1, y => 1} }

      it 'is satisfied' do
        subject.should eq(one)
      end
    end

    context 'on invalid input' do
      let(:input){ [ ] }
      
      it 'complements input with missing 2' do
        bdd_interface.eval(x, input).should eq(zero)
        bdd_interface.eval(!x, input).should eq(one)
      end
    end

    it 'is accessible as BDD#eval' do
      (x & y).eval([1, 1]).should eq(one)
      (x & y).eval([1, 0]).should eq(zero)
    end

  end
end
