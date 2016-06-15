#!/usr/bin/env ruby

require 'sinatra'
require 'json'

$stdout.sync = true

get '/current.:timestamp.jpeg' do |timestamp|
  begin
    data = ''
    path = "/tmp/#{timestamp}.jpeg"
    content_type "image/jpeg"
    if !File.exists? path
      puts "file does not already exist"
      take_webcam_image path
    else
      puts "using image from disk"
    end
    puts "file size: #{File.size(path)}"
    File.read path
  end
  # TODO: clean up old files, keep running 10?
end

HOSTS = {
  'robby' => 'lilnit:5052',
  'pingpong' => 'pingpongpi:5052'
}

post '/deskcheck' do
  message = JSON.parse(request.body.read)
  puts "received: #{message}"
  content_type 'application/json'
  if message['message'].start_with?('/deskcheck')
    puts "is desk check"
    target = message['message'].split[1]
    host = HOSTS[target]
    if host.nil? || host.empty?
      puts "target not found, noop: #{target}"
      response = "target [#{target}] not configured"
    else
      response = "<img src='http://#{host}/current.#{Time.now.to_i}.jpeg'/>"
    end
  else
    puts "is NOT desk check"
    response = nil
  end
  { message: response, format: 'html' }.to_json
end

def take_webcam_image path
  puts "taking webcame image => #{path}"
  cmd = "streamer -o #{path}" 
  puts "running cmd: #{cmd}"
  `#{cmd}`
end
