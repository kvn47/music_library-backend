require 'shellwords'

module Import
  class Perform < ATransaction
    step :prepare
    map :process

    private

    def prepare(input)
      albums = []
      splitted_files = []
      path = input[:path]
      Dir.chdir path

      input[:import_sources].each do |import_source|
        if import_source.key? :cue
          prefix = "#{File.basename(import_source[:file], '.*')} - "
          split_file import_source[:file], import_source[:cue], prefix

          import_source[:albums].each do |album|
            album[:tracks].collect! do |track|
              cue_track = format('%02d', track.delete(:cue_track))
              track[:path] = File.join path, "#{prefix + cue_track}.flac"
              splitted_files << track[:path]
              track
            end
            albums << album
          end
        else
          import_source[:albums].each do |album|
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
        Rails.logger.debug "[albums_params] #{album_params}"
        result = ProcessAlbum.new.(album_params.with_indifferent_access)

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
