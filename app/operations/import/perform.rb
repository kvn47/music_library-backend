require 'shellwords'

module Import
  class Perform
    include Dry::Transaction

    step :prepare
    map :process

    private

    def prepare(input)
      albums = []
      splitted_files = []

      input.each do |import_data|
        path = import_data[:path]
        if import_data.key? :cue
          Dir.chdir path
          prefix = "#{File.basename(import_data[:file], '.*')} - "
          split_file import_data[:file], import_data[:cue], prefix

          import_data[:albums].each do |album|
            album[:tracks].collect! do |track|
              cue_track = track.delete(:cue_track)
              track[:path] = File.join path, "#{prefix + cue_track}.flac"
              splitted_files << track[:path]
              track
            end
            albums << album
          end
        else
          import_data[:albums].each do |album|
            album[:tracks].collect! do |track|
              track[:path] = File.join path, track[:file]
              track
            end
            albums << album
          end
        end
      end

      Success albums: albums, splitted_files: splitted_files
    end

    def process(albums:, splitted_files:, **)
      results = {}

      albums.each do |album_params|
        result = ProcessAlbum.new.(album_params)

        results.store album_params[:title],
                      result: result.success? ? 'success' : 'failure',
                      message: result.value
      end

      FileUtils.rm_f splitted_files

      results
    end

    def split_file(file, cue_file, prefix)
      prefix = Shellwords.escape(prefix)
      cue_file = Shellwords.escape(cue_file)
      file = Shellwords.escape(file)

      `shnsplit -f #{cue_file} -a #{prefix} -o flac -O always #{file}`
      # `cuebreakpoints #{cue_file} | shnsplit -f #{cue_file} -a #{prefix} -o flac -O always #{file_name}`

      # Creating tag metadata
      # `cuetag #{cue_file} #{prefix}*.flac`
    end

    def convert_ape_files(files)
      files.each do |file|
        `shnconv -o flac -O always #{Shellwords.escape(file)}`
      end
    end
  end
end
