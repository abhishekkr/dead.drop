require 'sinatra'
require 'haml'

get '/' do
  redirect '/upload'
end

get '/upload' do
  haml :upload
end

post '/upload' do
  localdir = "cut_out__espionage"
  filename = params['dead_body'][:filename]
  tempfile = params['dead_body'][:tempfile]
  File.open("#{localdir}/#{filename}", "w") do |f|
    f.write(tempfile.read)
  end
  return "#{filename} was successfully uploaded!"
end
