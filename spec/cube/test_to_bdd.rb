require 'spec_helper'
module Cudd
  describe Cube, 'to_bdd' do

    subject{ c.to_bdd }

    before{ x; y; z  }

    context 'on x' do
      let(:c){ cube(x => true) }

      it 'returns the expected bdd' do
        subject.should eq(x)
      end
    end

    context 'on !x' do
      let(:c){ cube(x => false) }

      it 'returns the expected bdd' do
        subject.should eq(!x)
      end
    end

    context 'on x & y' do
      let(:c){ cube(x => true, y => true) }

      it 'returns the expected bdd' do
        subject.should eq(x & y)
      end
    end

  end
end