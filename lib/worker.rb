require 'drb/drb'
require 'thread'
require_relative 'queue'

class Worker
  include DRb::DRbUndumped

  def initialize
  end

  def do_work

  end

end