require 'sinatra'
require 'haml'
require 'securerandom'


$localdir = ENV['STASH'] || "cut_out__espionage"
Dir.mkdir $localdir unless File.exists? $localdir


class DeadDrop < Sinatra::Base
  get '/' do
    redirect '/stash'
  end

  get '/stash' do
    haml :stash
  end

  post '/stash' do
    begin
      filename = params['dead_body'][:filename]
      tempfile = params['dead_body'][:tempfile]
      new_filename = "#{SecureRandom.uuid}-#{filename}"
      localfilepath = File.join($localdir, new_filename)
      File.write(localfilepath, tempfile.read)
      return "
      <b>Congrats!</b><br/>
      #{filename} was successfully uploaded.<br/>
      Available at path <b>https://<my-domain>/stash/#{new_filename}</b>"
    rescue
      return "
      <b>Error 400</b><br/>
      there were some issues,<br/>try again in some time
      "
    end
  end

  get '/stash/:filename' do |filename|
    localfilepath = File.join($localdir, filename)
    File.expand_path(localfilepath)
    unless File.file?(localfilepath) and localfilepath.include?($localdir) then
      return "
      <b>Error 404</b><br/>
      <blockquote>Oh <i>#{filename}</i>,<br/> Where Art Thou!</blockquote>
      "
    end
    send_file localfilepath
  end

  get '/ping' do
    return "pong"
  end
end
