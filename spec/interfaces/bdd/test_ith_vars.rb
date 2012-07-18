require 'spec_helper'
module Cudd
  describe Interface::BDD, 'ith_vars' do

    subject{ bdd_interface.ith_vars(*Array(arg)) }

    context "with a single Integer" do
      let(:arg){ 2 }

      it 'returns [ z ]' do
        subject.should eq([ z ])
      end
    end

    context "with multiple Integers" do
      let(:arg){ [ 0, 2 ] }

      it 'returns [ x, z ]' do
        subject.should eq([ x, z ])
      end
    end

    context "with multiple Integers in an Array" do
      let(:arg){ [[ 0, 2 ]] }

      it 'returns [ x, z ]' do
        subject.should eq([ x, z ])
      end
    end

    context "with multiple Integers in a Range" do
      let(:arg){ 0..1 }

      it 'returns [ x, y ]' do
        subject.should eq([ x, y ])
      end
    end

  end
end
