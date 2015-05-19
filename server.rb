require 'rubygems'
require 'bundler/setup'
require 'tilt'
require 'erb'
require 'webrick'
require 'yaml'
require 'slim'

ROOT = File.dirname(__FILE__)

PORT = ENV["PORT"] || 8000

server = WEBrick::HTTPServer.new(:Port => PORT)

server.mount '/assets', WEBrick::HTTPServlet::FileHandler, "#{ROOT}/public"

server.mount_proc '/' do |req, res|
  page_title = "Hack News Mock"
  hack = YAML.load_file("#{ROOT}/content.yml")
  template = Tilt.new("#{ROOT}/index.slim")
  res.body = template.render(self, {:hack => hack, :page_title => page_title}, )
end

server.mount_proc '/stylesheet.css' do |req, res|
  res.body = Tilt.new("#{ROOT}/stylesheet.scss").render
end

trap 'INT' do
  server.shutdown
end

server.start