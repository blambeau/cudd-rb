require 'spec_helper'
module Cudd
  describe Cube, '==' do

    subject{ cube1 == cube2 }

    before{ x; y; z  }

    context 'on equal cubes' do
      let(:cube1){ cube(x => true, y => false) }
      let(:cube2){ cube(x => true, y => false) }
      it{ should be_true }
    end

    context 'on non equal cubes' do
      let(:cube1){ cube(x => true, y => false) }
      let(:cube2){ cube(x => false) }
      it{ should be_false }
    end

  end
end