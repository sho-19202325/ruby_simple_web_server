require "socket"
require "./server_thread"

server = TCPServer.open(3030)

begin 
  loop do
    puts "クライアントからの接続を待ちます"
    Thread.start(server.accept) do |socket|
      puts "クライアント接続"
      server_thread = ServerThread.new(socket)
      server_thread.run
    end
  end
rescue => e
  puts e
ensure
  server.close
end