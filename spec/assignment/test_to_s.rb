require 'spec_helper'
module Cudd
  describe Assignment, "to_s" do

    before do
      x; y; z
    end

    subject{ bdd_interface.assignment(input).to_s }

    context 'when built with an array of integers' do
      let(:input){ [1, 0, 2] }

      it 'transforms 2s to dashes' do
        subject.should eq("10-")
      end 
    end

  end
end