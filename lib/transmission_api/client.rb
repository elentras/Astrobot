require "httparty"
require "json"

module TransmissionApi
  class Client

    def self.build(method, opts = {})
      TransmissionApi::Client.post(
        :method => method,
        :arguments => opts
      )
    end

    def self.post(opts)
      JSON::parse( http_post(opts).body )
    end

    def self.http_post(opts, try_counter = 0)
      post_options = {
        :body => opts.to_json,
        :headers => { "x-transmission-session-id" => TransmissionApi.config[:session_id] }
      }
      post_options.merge!( :basic_auth => TransmissionApi.config[:basic_auth]) unless 
        TransmissionApi.config[:basic_auth].nil?

      TransmissionApi::Logger.add "url: #{TransmissionApi.config[:url]}"
      TransmissionApi::Logger.add "post_body:"
      TransmissionApi::Logger.add JSON.parse(post_options[:body]).to_yaml
      TransmissionApi::Logger.add "------------------"

      response = HTTParty.post(TransmissionApi.config[:url], post_options)

      TransmissionApi::Logger.debug response

      # retry connection 3 times if session_id incorrect
      if( response.code == 409 and try_counter <= 3)
        TransmissionApi::Logger.add "changing session_id"
        TransmissionApi.configure(:session_id => response.headers["x-transmission-session-id"])
        try_counter.next
        response = http_post(opts, try_counter)
      end
      response
    end
  end
end