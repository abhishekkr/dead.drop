$: << File.expand_path(File.dirname(__FILE__))
require 'server'

use Rack::ShowExceptions

run DeadDrop
