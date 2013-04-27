require "httparty"
require "json"

module Astrobot
  class Client

    def self.build(method, opts = {})
      Astrobot::Client.post(
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
        :headers => { "x-transmission-session-id" => Astrobot.config[:session_id] }
      }
      post_options.merge!( :basic_auth => Astrobot.config[:basic_auth]) unless 
        Astrobot.config[:basic_auth].nil?

      Astrobot::Logger.add "url: #{Astrobot.config[:url]}"
      Astrobot::Logger.add "post_body:"
      Astrobot::Logger.add JSON.parse(post_options[:body]).to_yaml
      Astrobot::Logger.add "------------------"

      response = HTTParty.post(Astrobot.config[:url], post_options)

      Astrobot::Logger.debug response

      # retry connection 3 times if session_id incorrect
      if( response.code == 409 and try_counter <= 3)
        Astrobot::Logger.add "changing session_id"
        Astrobot.configure(:session_id => response.headers["x-transmission-session-id"])
        try_counter.next
        response = http_post(opts, try_counter)
      end
      response
    end
  end
end