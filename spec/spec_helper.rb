$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'cudd-rb'

require_relative 'shared/a_bdd'

module Helpers

  def with_manager(&bl)
    Cudd.manager(&bl)
  end

end

RSpec.configure do |c|
  c.include(Helpers)
end