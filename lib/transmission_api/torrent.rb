module TransmissionApi
  class Torrent

    def self.all(fields = TransmissionApi::TORRENT_FIELDS)
      Logger.add "get_torrents"
      opts = { :fields => fields }
      response = build("torrent-get", opts)

      response["arguments"]["torrents"]
    end

    def self.find(id, fields = TransmissionApi::TORRENT_FIELDS)
      raise StandardError, "missing :id in params" unless id
      Logger.add "get_torrent: #{id}"
      id = [id] unless id.class == Array
      opts = { :fields => fields, :ids => id }

      response = build("torrent-get", opts)

      response["arguments"]["torrents"]
    end

    def self.create(filename)
      raise StandardError, "missing :filename in params" unless filename
      Logger.add "add_torrent: #{filename}"
      opts = {:filename => filename}

      response = build("torrent-add", opts)
      response["arguments"]["torrent-added"]
    end

    def self.destroy(id)
      raise StandardError, "missing :id in params" unless id

      Logger.add "remove_torrent: #{id}"
      opts = { :ids => [id], :"delete-local-data" => true }

      build("torrent-remove", opts)
    end

    private
      def self.build(method, opts = {})
        TransmissionApi::Client.post(
          :method => method,
          :arguments => opts
        )
      end
  end
end