module TransmissionApi
  class Torrent

    def self.all(fields = TransmissionApi::TORRENT_FIELDS)
      Logger.add "get_torrents"
      opts = { :fields => fields }
      response = TransmissionApi::Client.build("torrent-get", opts)

      convert_hash_keys(response["arguments"]["torrents"])
    end

    def self.find(id, fields = TransmissionApi::TORRENT_FIELDS)
      raise StandardError, "missing :id in params" unless id
      Logger.add "get_torrent: #{id}"
      id = [id] unless id.class == Array
      opts = { :fields => fields, :ids => id }

      response = TransmissionApi::Client.build("torrent-get", opts)
      convert_hash_keys(response["arguments"]["torrents"]).first
    end

    def self.create(filename)
      raise StandardError, "missing :filename in params" unless filename
      Logger.add "add_torrent: #{filename}"
      opts = {:filename => filename}

      response = TransmissionApi::Client.build("torrent-add", opts)
      response["arguments"]["torrent-added"]
    end

    def self.destroy(id)
      raise StandardError, "missing :id in params" unless id

      Logger.add "remove_torrent: #{id}"
      opts = { :ids => [id], :"delete-local-data" => true }

      TransmissionApi::Client.build("torrent-remove", opts)
    end

    private
    def self.underscore_key(k)
      k.to_s.underscore.to_sym
      # Or, if you're not in Rails:
      # to_snake_case(k.to_s).to_sym
    end
    def self.convert_hash_keys(value)
      case value
        when Array
          value.map { |v| convert_hash_keys(v) }
          # or `value.map(&method(:convert_hash_keys))`
        when Hash
          Hash[value.map { |k, v| [underscore_key(k), convert_hash_keys(v)] }]
        else
          value
       end
    end

    def self.serialize_response(response)
      result = {}
      response.map do |key, value|
        result[key.underscore.to_sym] = value
      end
      puts "Result serialized = #{result.to_yaml}"
      result
    end
    
  end
end