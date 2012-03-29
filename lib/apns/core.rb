require 'socket'
require 'openssl'
require 'json'

module APNS
  class Pusher
    DEFAULT_HOST = 'gateway.sandbox.push.apple.com'
    DEFAULT_PORT = 2195
    
    attr_accessor :host, :pem, :port, :pass
    
    def initialize(options={})
      @host = options[:host] || DEFAULT_HOST
      @port = options[:port] || DEFAULT_PORT
      # openssl pkcs12 -in mycert.p12 -out client-cert.pem -nodes -clcerts -passin pass:password
      @pem = options[:pem] # this should be the content of the pem file
      @pem_filepath = options[:pem_filepath] || "" # pem file path
      @pass = options[:pass]
    end
    
    def send_notification(device_token, message)
      n = APNS::Notification.new(device_token, message)
      send_notifications([n])
    end

    def send_notifications(notifications)
      sock, ssl = open_connection

      notifications.each do |n|
        ssl.write(n.packaged_notification)
      end

      ssl.close
      sock.close
    end

    def feedback
      sock, ssl = feedback_connection

      apns_feedback = []

      while line = sock.gets   # Read lines from the socket
        line.strip!
        f = line.unpack('N1n1H140')
        apns_feedback << [Time.at(f[0]), f[2]]
      end

      ssl.close
      sock.close

      return apns_feedback
    end

    protected
    def ssl_context
      unless File.exist?(@pem_filepath) || @pem
        raise 
        '''
          The pem certificate is not set. 
          (pem_filepath = {/path/to/cert.pem} || pem = {pem_file_content})
        '''
      end
      
      @pem = File.read(@pem_filepath) unless @pem
      
      context      = OpenSSL::SSL::SSLContext.new
      context.cert = OpenSSL::X509::Certificate.new(@pem)
      context.key  = OpenSSL::PKey::RSA.new(@pem, @pass)
      context
    end
    
    def open_connection
      context = self.ssl_context()
      
      sock         = TCPSocket.new(@host, @port)
      ssl          = OpenSSL::SSL::SSLSocket.new(sock,context)
      ssl.connect

      return sock, ssl
    end

    def feedback_connection
      context = self.ssl_context()
      
      fhost = @host.gsub('gateway','feedback')
      # puts fhost

      sock         = TCPSocket.new(fhost, 2196)
      ssl          = OpenSSL::SSL::SSLSocket.new(sock,context)
      ssl.connect

      return sock, ssl
    end

  end
end
