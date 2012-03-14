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
      # openssl pkcs12 -in mycert.p12 -out client-cert.pem -nodes -clcerts
      @pem = options[:pem] # this should be the path of the pem file not the contentes
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

    def open_connection
      raise "The path to your pem file is not set. (APNS.pem = /path/to/cert.pem)" unless @pem
      raise "The path to your pem file does not exist!" unless File.exist?(@pem)

      context      = OpenSSL::SSL::SSLContext.new
      context.cert = OpenSSL::X509::Certificate.new(File.read(@pem))
      context.key  = OpenSSL::PKey::RSA.new(File.read(@pem), @pass)

      sock         = TCPSocket.new(@host, @port)
      ssl          = OpenSSL::SSL::SSLSocket.new(sock,context)
      ssl.connect

      return sock, ssl
    end

    def feedback_connection
      raise "The path to your pem file is not set. (APNS.pem = /path/to/cert.pem)" unless @pem
      raise "The path to your pem file does not exist!" unless File.exist?(@pem)

      context      = OpenSSL::SSL::SSLContext.new
      context.cert = OpenSSL::X509::Certificate.new(File.read(@pem))
      context.key  = OpenSSL::PKey::RSA.new(File.read(@pem), @pass)

      fhost = @host.gsub('gateway','feedback')
      # puts fhost

      sock         = TCPSocket.new(fhost, 2196)
      ssl          = OpenSSL::SSL::SSLSocket.new(sock,context)
      ssl.connect

      return sock, ssl
    end

  end
end
