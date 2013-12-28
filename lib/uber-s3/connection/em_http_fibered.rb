require 'eventmachine'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'

module UberS3::Connection
  class EmHttpFibered < Adapter

    def request(verb, url, headers={}, body=nil)
      params = {}
      params[:head] = headers
      params[:body] = body if body
      params[:redirects] = 10
      # params[:keepalive] = true if persistent # causing issues ...?

      retries = 4
      begin
        r = EM::HttpRequest.new(url, :inactivity_timeout => 10, :connect_timeout => 10).send(verb, params)

        UberS3::Response.new({
          :status => r.response_header.status,
          :header => r.response_header,
          :body   => r.response,
          :raw    => r
        })
      rescue UberS3::Error::InternalError => e
        class_name = e.class.name.split('::').last
        ::Utils::Statsd.increment("ubers3.exception.#{class_name}.retry")
        retries -= 1
        retry if retries >= 0
        raise e
      end
    end

  end
end
