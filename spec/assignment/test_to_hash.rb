require 'spec_helper'
module Cudd
  describe Assignment, "to_hash" do

    before do
      x
    end

    subject{ bdd_interface.assignment(input).to_hash }

    context 'on a single variable assignment' do
      let(:input){ [ 1 ] }

      it 'returns a Hash mapping x to its truth value' do
        subject.should eq(x => true)
      end
    end

    context 'on a multiple variable assignment with dont care' do
      let(:input){ [ 0, 2, 1 ] }

      it 'returns a Hash mapping x and z to their truth value' do
        subject.should eq(x => false, z => true)
      end
    end

  end
end
