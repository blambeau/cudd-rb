require 'spec_helper'
module Cudd
  describe Cube, 'to_truths' do

    subject{ c.to_truths }

    before{ x; y; z  }

    context 'on x' do
      let(:c){ cube(x => true) }

      it 'returns the expected bdd' do
        subject.should eq([true, nil, nil])
      end
    end

    context 'on !x' do
      let(:c){ cube(x => false) }

      it 'returns the expected bdd' do
        subject.should eq([false, nil, nil])
      end
    end

    context 'on x & y' do
      let(:c){ cube(x => true, y => true) }

      it 'returns the expected bdd' do
        subject.should eq([true, true, nil])
      end
    end

  end
end