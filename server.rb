require 'sinatra'
require 'haml'

$localdir = ENV['STASH'] || "cut_out__espionage"
Dir.mkdir $localdir unless File.exists? $localdir

get '/' do
  redirect '/stash'
end

get '/stash' do
  haml :stash
end

post '/stash' do
  filename = params['dead_body'][:filename]
  tempfile = params['dead_body'][:tempfile]
  File.write("#{$localdir}/#{filename}", tempfile.read)
  return "#{filename} was successfully uploaded!"
end
