require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "cube" do

      before do
        x; y; z
      end

      subject{ cube(arg, as) }

      describe "as => :012" do
        let(:as){ :a012 }

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

        context 'when an array of BDD variables' do
          let(:arg){ [!y, x] }
          it { should eq([ 1, 0, 2 ]) }
        end

        context 'when a Hash' do
          let(:arg){ {x => 1, y => false} }
          it { should eq([ 1, 0, 2 ]) }
        end
      end

      describe 'as => :bdd' do
        let(:as){ :bdd }

        context 'when an array of BDD variables' do
          let(:arg){ [!y, x] }
          it { should eq(x & !y) }
        end
      end

      describe 'as => :hash' do
        let(:as){ :hash }

        context 'when an array of BDD variables' do
          let(:arg){ [!y, x] }
          it { should eq(x => true, y => false) }
        end
      end

    end
  end
end
