require 'spec_helper'
module Cudd
  describe Cube, 'to_hash' do

    subject{ c.to_hash }

    before{ x; y; z  }

    context 'on x' do
      let(:c){ cube(x => true) }

      it 'returns the expected bdd' do
        subject.should eq(x => true)
      end
    end

    context 'on !x' do
      let(:c){ cube(x => false) }

      it 'returns the expected bdd' do
        subject.should eq(x => false)
      end
    end

    context 'on x & y' do
      let(:c){ cube(x => true, y => true) }

      it 'returns the expected bdd' do
        subject.should eq(x => true, y => true)
      end
    end

  end
end