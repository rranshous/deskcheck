#!/usr/bin/env ruby

require 'sinatra'
require 'json'

$stdout.sync = true

get '/employee_tools_desk.jpeg' do
  path = nil
  begin
    path = take_webcam_image
    content_type "image/jpeg"
    puts "image path: #{path}"
    puts "file size: #{File.size(path)}"
    File.read path
  ensure
    if path
      puts "removing file"
      File.unlink path
    end
  end
end

post '/deskcheck' do
  message = JSON.parse(request.body.read)
  puts "received: #{message}"
  content_type 'application/json'
  if message['message'].start_with?('/deskcheck')
    puts "is desk check"
    response = "<img src='http://lilnit:5052/employee_tools_desk.jpeg'/>"
  else
    puts "is NOT desk check"
    response = nil
  end
  { message: response, format: 'html' }.to_json
end

def take_webcam_image
  puts "taking webcame image"
  tmp_path = "/tmp/#{Time.now.to_f}.jpeg"
  cmd = "streamer -o #{tmp_path}" 
  puts "running cmd: #{cmd}"
  `#{cmd}`
  tmp_path
end
