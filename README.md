# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

### Dependencies

**MacOS** 

brew install cuetools shntool flac

mv /usr/local/bin/cuetag.sh /usr/local/bin/cuetag

Change METAFLAC in the /usr/local/bin/cuetag to: METAFLAC="metaflac --import-tags-from=-"

**Ubuntu**

apt-get install cuetools shntool flac libtag1-dev

sudo add-apt-repository ppa:mc3man/xerus-media

sudo apt-get update

sudo apt-get install monkeys-audio

### Useful Links

http://etree.org/shnutils/shntool/

https://xiph.org/flac/index.html

http://en.linuxreviews.org/HOWTO_splitt_lossless_audio_files_(ape,_flac,_wv,_wav)_using_.cue_files
