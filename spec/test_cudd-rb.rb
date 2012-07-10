require 'spec_helper'
describe Cudd do

  it "should have a version number" do
    Cudd.const_defined?(:VERSION).should be_true
  end

end
