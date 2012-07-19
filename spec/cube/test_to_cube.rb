require 'spec_helper'
module Cudd
  describe Cube, 'to_cube' do

    subject{ c.to_bdd }

    before{ x; y; z  }

    context 'on x & y' do
      let(:c){ cube(x => true, y => true) }

      it 'returns itself' do
        subject.should eq(subject)
      end
    end

  end
end