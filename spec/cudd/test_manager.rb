require 'spec_helper'
module Cudd
  describe ".manager" do

    it 'passes the manager to the block, closes it afterwards and returns block result' do
      manager = nil
      result = Cudd.manager do |m|
        manager = m
        m.should be_a(Cudd::Manager)
        m.should be_alive
        m.should_not be_closed
        12
      end
      result.should eq(12)
      manager.should_not be_alive
      manager.should be_closed
    end

    it 'returns an alive manager if no block' do
      begin
        manager = Cudd.manager
        manager.should be_alive
      ensure
        manager.close if manager
      end
    end

    it 'sets options correctly' do
      Cudd.manager :maxMemory => 10 do |m|
        m.options[:maxMemory].should eq(10)
      end
    end

  end
end