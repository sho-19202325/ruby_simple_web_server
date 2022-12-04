require "socket"

socket = TCPSocket.new("localhost", 8081)

# client_send.txtの内容を一行ずつ書き込む
File.foreach("client_send.txt") do |file_line|
  socket.write(file_line)
end

socket.write("\r\n")

File.open("client_recv.txt", "w") do |file|
  while ch = socket.read(1)
    file.write(ch)
  end
end