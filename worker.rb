require 'drb/drb'

class Worker
  include DRb::DRbUndumped

  def initialize(uri)
    @uri = uri
  end

  def perform(object, method)
    # not safe, I know. Don't have a real task to define so just letting the client define it for demo flexibility
    result = object.send(method)
    puts "Worker on #{uri} calling :#{method} on #{object} object => #{result}"
    result
  end
  
  private 
  attr_reader :uri
end