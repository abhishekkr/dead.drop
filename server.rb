require 'sinatra'
require 'haml'

get '/' do
  redirect '/stash'
end

get '/stash' do
  haml :stash
end

post '/stash' do
  localdir = "cut_out__espionage"
  filename = params['dead_body'][:filename]
  tempfile = params['dead_body'][:tempfile]
  File.open("#{localdir}/#{filename}", "w") do |f|
    f.write(tempfile.read)
  end
  return "#{filename} was successfully uploaded!"
end
