require 'spec_helper'
module Cudd
  describe Cube, 'to_a012' do

    subject{ c.to_a012 }

    before{ x; y; z  }

    context 'on x' do
      let(:c){ cube(x => true) }

      it 'returns the expected bdd' do
        subject.should eq([1, 2, 2])
      end
    end

    context 'on !x' do
      let(:c){ cube(x => false) }

      it 'returns the expected bdd' do
        subject.should eq([0, 2, 2])
      end
    end

    context 'on x & y' do
      let(:c){ cube(x => true, y => true) }

      it 'returns the expected bdd' do
        subject.should eq([1, 1, 2])
      end
    end

  end
end