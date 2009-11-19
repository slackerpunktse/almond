require 'rubygems'
require 'sinatra/base'
require 'haml'

class AlmondServer< Sinatra::Base
  DEFAULT_HOST = 'localhost'
  DEFAULT_PORT = 2412

  def initialize
    @code_repository = "/tmp/almond/data"
  end

  dir = File.dirname(File.expand_path(__FILE__))
  set :views,  "#{dir}/views"

  def self.start()
    self.run! :host => DEFAULT_HOST, :port => DEFAULT_PORT
  end

  helpers do
    def trigger_happy(trigger, args='')
      mayhaps = File.join(@code_repository, trigger)
      puts mayhaps
      if File.executable?(mayhaps)
        # execute file
        return %x["#{mayhaps}"]
      else
        halt 404, "sorry, trigger not found."
      end
    end
  end

  get '/' do
    "oh, hello!"
  end

  get '/:trigger' do |trigger|
    trigger_happy(trigger)
  end

  get '/:trigger/*' do |trigger, args|
    trigger_happy(trigger, args)
  end
end
