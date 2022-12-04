require "socket"

begin
  server = TCPServer.open(3030)
  puts "クライアントからの接続を待ちます。"
  socket = server.accept()
  puts "クライアント接続"

  puts "リクエストの読み込み"
  File.open("server_recv.txt", "w") do |file|
    while (line = socket.gets) != "0\n"
      path = line.split(" ")[1] if line.start_with?("GET")
      file.write(line)
    end
  end

  File.foreach("server_send.txt") do |file_line|
    socket.write(file_line)
  end
rescue => e
  puts e
ensure
  socket.close
  server.close
end
