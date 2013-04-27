module Astrobot
  class Controls
    
    # 3.1.  Torrent Action Requests
    # 
    #    Method name          | libtransmission function
    #    ---------------------+-------------------------------------------------
    #    "torrent-start"      | tr_torrentStart
    #    "torrent-start-now"  | tr_torrentStartNow
    #    "torrent-stop"       | tr_torrentStop
    #    "torrent-verify"     | tr_torrentVerify
    #    "torrent-reannounce" | tr_torrentManualUpdate ("ask tracker for more peers")
    # 
    #    Request arguments: "ids", which specifies which torrents to use.
    #                   All torrents are used if the "ids" argument is omitted.
    #                   "ids" should be one of the following:
    #                   (1) an integer referring to a torrent id
    #                   (2) a list of torrent id numbers, sha1 hash strings, or both
    #                   (3) a string, "recently-active", for recently-active torrents
    # 
    #    Response arguments: none
    def self.do(ids, action)
      Logger.add "torrent-#{action.to_s} on #{ids}"
      ids = [ids] unless ids.class == Array
      ids = ids.map { |id| id.to_i }
      opts = { :ids => ids }
      
      response = Astrobot::Client.build("torrent-#{action.to_s}", opts)
    end
  end
end