require "httparty"
require "json"

module TransmissionApi
  class Client

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

      Logger.add "url: #{TransmissionApi.config[:url]}"
      Logger.add "post_body:"
      Logger.add JSON.parse(post_options[:body]).to_yaml
      Logger.add "------------------"

      response = HTTParty.post(TransmissionApi.config[:url], post_options)

      Logger.debug response

      # retry connection 3 times if session_id incorrect
      if( response.code == 409 and try_counter <= 3)
        Logger.add "changing session_id"
        TransmissionApi.configure(:session_id => response.headers["x-transmission-session-id"])
        try_counter.next
        response = http_post(opts, try_counter)
      end
      response
    end
  end
end