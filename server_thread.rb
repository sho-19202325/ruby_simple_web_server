require "socket"
require "cgi"
require "./http_response"

class ServerThread
  def initialize(socket)
    @socket = socket
  end

  def run
    begin
      while (line = @socket.gets) != "\r\n"
        path = line.split(" ")[1] if line&.start_with?("GET")
      end

      decoded_path = CGI.unescape(path)
      decoded_path_to_file = File.join(Util::BASE_DIR, decoded_path)

      # 指定されたpathが、無効ならばnot_foundを返す
      return HttpResponse.send_not_found(@socket) if !Util.is_valid_path?(decoded_path)

      if File.directory?(decoded_path_to_file)
        # ディレクトリを指定している場合は、index.htmlを返す
        decoded_path_to_file = File.join(decoded_path, "index.html")
        location = "http://localhost:3030#{decoded_path_to_file}"
        HttpResponse.send_moved_permanently(@socket, location)
      elsif File.exist?(decoded_path_to_file)
        HttpResponse.send_ok(@socket, decoded_path_to_file)
      else
        HttpResponse.send_not_found(@socket)
      end
    rescue => e
      puts e
    ensure
      @socket.close
    end
  end
end
