module TransmissionApi
  class Logger
    def self.add(message)
      Kernel.puts "[TransmissionApi #{Time.now.strftime( "%F %T" )}] #{message}" if TransmissionApi.config[:debug_mode]
    end

    def self.debug(response)
      body = nil
      begin
        body = JSON.parse(response.body).to_yaml
      rescue
        body = response.body
      end

      headers = response.headers.to_yaml

      add "response.code: #{response.code}"
      add "response.message: #{response.message}"

      add "response.body:"
      add body
      add "-----------------"

      add "response.headers:"
      add headers
      add "------------------"
    end
  end
end