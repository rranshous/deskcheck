#!/usr/bin/env ruby

require 'sinatra'
require 'json'

$stdout.sync = true

get '/employee_tools_desk.:timestamp.jpeg' do |timestamp|
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
end

post '/deskcheck' do
  message = JSON.parse(request.body.read)
  puts "received: #{message}"
  content_type 'application/json'
  if message['message'].start_with?('/deskcheck')
    puts "is desk check"
    response = "<img src='http://lilnit:5052/employee_tools_desk.#{Time.now.to_i}.jpeg'/>"
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
