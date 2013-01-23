module TransmissionApi
  class Torrent

    def self.all(fields = TransmissionApi::TORRENT_FIELDS)
      Logger.add "get_torrents"
      method = "torrent-get"
      opts = { :fields => fields }
      response = build(method, opts)

      response["arguments"]["torrents"]
    end

    def self.find(id, fields = TransmissionApi::TORRENT_FIELDS)
      raise StandardError, "missing :id in params" unless id

      Logger.add "get_torrent: #{id}"
      id = [id] unless id.class == Array
      method = "torrent-get"
      opts = { :fields => fields, :ids => id }
      response = build(method, opts)

      response["arguments"]["torrents"]
    end

    def self.create(filename)
      raise StandardError, "missing :filename in params" unless filename

      Logger.add "add_torrent: #{filename}"
      method = "torrent-add"
      opts = {:filename => filename}

      response = build(method, opts)
      response["arguments"]["torrent-added"]
    end

    def self.destroy(id)
      raise StandardError, "missing :id in params" unless id

      Logger.add "remove_torrent: #{id}"
      method = "torrent-remove"
      opts = { :ids => [id], :"delete-local-data" => true }

      build(method, opts)
    end

    private
      def self.build(method, opts = {})
        TransmissionApi::Client.post(
          :method => "torrent-remove",
          :arguments => opts
        )
      end
  end
end