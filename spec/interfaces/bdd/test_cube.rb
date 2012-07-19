require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "cube" do

      before do
        x; y; z
      end

      subject{ bdd_interface.cube(arg) }

      context 'when already a cube' do
        let(:arg){ [ 1, 0, 2 ] }
        it { should eq([ 1, 0, 2 ]) }
      end

      context 'when an incomplete cube' do
        let(:arg){ [ 1, 0 ] }
        it { should eq([ 1, 0, 2 ]) }
      end

      context 'when truth values' do
        let(:arg){ [ true, false, nil ] }
        it { should eq([ 1, 0, 2 ]) }
      end

      context 'when a Hash' do
        let(:arg){ {x => 1, y => false} }
        it { should eq([ 1, 0, 2 ]) }
      end

    end
  end
end
