require 'spec_helper'
module Cudd
  describe Interface::BDD, 'is_complement' do

    context 'on ZERO' do
      subject{ zero.is_complement? }
      it{ should be_true }
    end

    context 'on ONE' do
      subject{ one.is_complement? }
      it{ should be_false }
    end

    context 'on x' do
      subject{ x.is_complement? }
      it{ should be_false }
    end

    context 'on !x' do
      subject{ !x.is_complement? }
      it{ should be_true }
    end

  end
end
