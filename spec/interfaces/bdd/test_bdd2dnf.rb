require 'spec_helper'
module Cudd
  module Interfaces
    describe BDD, "bdd2dnf" do

      before do
        x; y; z
      end

      subject{ bdd.to_dnf }

      context 'on ZERO' do
        let(:bdd){ zero }
        it{ should eq("false") }
      end

      context 'on ONE' do
        let(:bdd){ one }
        it{ should eq("true") }
      end

      context 'on an unnamed variable' do
        let(:bdd){ x }
        it{ should eq("v0") }
      end

      context 'on an named variable' do
        let(:bdd){ bdd_interface.new_var(:foo) }
        it{ should eq("foo") }
      end

      context 'on an complex formula' do
        let(:bdd){ (x | y) & z }
        it{ should eq("(!v0 & v1 & v2) | (v0 & v2)") }
      end

    end
  end
end
