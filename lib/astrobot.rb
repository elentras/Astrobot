require "astrobot/version"
require 'yaml'

module Astrobot
  # Loading classes to easier access
  # NOTE: I like this way to handle my classes,
  #   sexiest than using require 'my_class_file' everywhere
  autoload :Torrent, 'astrobot/torrent'
  autoload :Controls, 'astrobot/controls'
  autoload :Client, 'astrobot/client'
  autoload :Logger, 'astrobot/logger'

  TORRENT_FIELDS = [
    "id",
    "name",
    'status',
    "totalSize",
    "addedDate",
    "isFinished",
    "rateDownload",
    "rateUpload",
    "percentDone",
    "files"
  ]
  
  TORRENT_ALL_FIELDS = [
    'addedDate',
    'bandwidthPriority',
    'comment',
    'corruptEver',
    'creator',
    'dateCreated',
    'desiredAvailable',
    'doneDate',
    'downloadDir',
    'downloadedEver',
    'downloadLimit',
    'downloadLimited',
    'error',
    'errorString',
    'eta',
    'etaIdle',
    'files',
    'fileStats',
    'hashString',
    'haveUnchecked',
    'haveValid',
    'honorsSessionLimits',
    'id',
    'isFinished',
    'isPrivate',
    'isStalled',
    'leftUntilDone',
    'magnetLink',
    'manualAnnounceTime',
    'maxConnectedPeers',
    'metadataPercentComplete',
    'name',
    'peer-limit',
    'peers',
    'peersConnected',
    'peersFrom',
    'peersGettingFromUs',
    'peersSendingToUs',
    'percentDone',
    'pieces',
    'pieceCount',
    'pieceSize',
    'priorities',
    'queuePosition',
    'rateDownload(B/s)',
    'rateUpload(B/s)',
    'recheckProgress',
    'secondsDownloading',
    'secondsSeeding',
    'seedIdleLimit',
    'seedIdleMode',
    'seedRatioLimit',
    'seedRatioMode',
    'sizeWhenDone',
    'startDate',
    'status',
    'trackers',
    'trackerStats',
    'totalSize',
    'torrentFile',
    'uploadedEver',
    'uploadLimit',
    'uploadLimited',
    'uploadRatio',
    'wanted',
    'webseeds',
    'webseedsSendingToUs'
  ]

  # Configuration defaults
  @@config = {
    url: 'http://127.0.0.1:9091/transmission/rpc',
    fields: TORRENT_ALL_FIELDS,
    basic_auth: { :username => '', :password => '' },
    session_id: "NOT-INITIALIZED",
    debug_mode: false
  }

  YAML_INITIALIZER_PATH = File.dirname(__FILE__)
  @valid_config_keys = @@config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @@config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  # for ruby scripting usage
  def self.configure_with(yaml_file_path = nil)
    yaml_file_path = YAML_INITIALIZER_PATH  unless yaml_file_path
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      Logger.add(:warning, "YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      Logger.add(:warning, "YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  # Access to config variables
  def self.config
    @@config = configure unless @@config
    @@config
  end
end