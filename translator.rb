require 'erb'
require 'webrick'
require 'yaml'

ROOT = File.dirname(__FILE__)

server = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => "#{ROOT}/public")

server.mount_proc '/content' do |req, res|
  @page_title = "Hack News Mock"
  @hack = YAML.load_file("#{ROOT}/post.yml")
  template = ERB.new(File.read("#{ROOT}/index.html.erb"))
  res.body = template.result
end

trap 'INT' do
  server.shutdown
end

server.start