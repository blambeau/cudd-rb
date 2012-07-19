require 'spec_helper'
module Cudd
  describe Cube, 'new' do

    subject{ Cube.new(bdd_interface, arg) }

    before{ 
      x; y; z 
      subject.should be_a(Cube)
    }

    shared_examples_for "A cube for x=1,y=0,z=2" do
      it 'has [1,0,2] has to_a012' do
        subject.to_a012.should eq([1, 0, 2])
      end 
    end

    context 'when an array of 012' do
      let(:arg){ [ 1, 0, 2 ] }
      it_behaves_like "A cube for x=1,y=0,z=2"
    end

    context 'when an incomplete array of 012' do
      let(:arg){ [ 1, 0 ] }
      it_behaves_like "A cube for x=1,y=0,z=2"
    end

    context 'when truth values' do
      let(:arg){ [ true, false, nil ] }
      it_behaves_like "A cube for x=1,y=0,z=2"
    end

    context 'when an array of BDD variables' do
      let(:arg){ [!y, x] }
      it_behaves_like "A cube for x=1,y=0,z=2"
    end

    context 'when a Hash' do
      let(:arg){ {x => 1, y => false} }
      it_behaves_like "A cube for x=1,y=0,z=2"
    end

    context 'when a BDD' do
      let(:arg){ x & !y }
      it_behaves_like "A cube for x=1,y=0,z=2"
    end

  end
end