require 'spec_helper'
module Cudd
  describe Assignment, "to_s" do

    subject{ x; y; z; Assignment.new(bdd_interface, input).to_s }

    context 'when built with an array of integers' do
      let(:input){ [1, 0, 2] }

      it 'transforms 2s to dashes' do
        subject.should eq("10-")
      end 
    end

  end
end