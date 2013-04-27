# Astrobot

More complex version from the * [Very simple Ruby Gem](https://github.com/dsander/transmission-client) to comunicate with the Transmission API.

There are other alternatives, this one just works better for me but I recommend you to check out the others.:

* [Transmission Client](https://github.com/dsander/transmission-client)
* [Transmission Connector](https://github.com/mattissf/transmission-connector)


## Installation

Add this line to your application"s Gemfile:

    gem "astrobot"

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install astrobot

## Usage

      Astrobot.configure(
        :username => "username",
        :password => "password",
        :url      => "http://127.0.0.1:9091/transmission/rpc"

    torrents = Astrobot::Torrent.all
    torrent = Astrobot::Torrent.find(id)
    torrent = Astrobot::Torrent.create("http://torrent.com/nice_pic.torrent")
    Astrobot::Torrent.destroy(id)

## State

Version experimental, currently tesing in production. <:D

## Transmission Api Doc

* https://trac.transmissionbt.com/browser/trunk/extras/rpc-spec.txt

Supported Transmission Api Version: 2.40

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Added some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
