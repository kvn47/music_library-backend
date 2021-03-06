require 'shellwords'

class ImportMusic < ATransaction
  include BroadcastLogs

  step :prepare
  map :process

  private

  def prepare(input)
    albums = []
    track_files = []
    path = input[:path]
    Dir.chdir path

    input[:source_infos].each do |source_info|
      if source_info[:cue]
        prefix = "#{File.basename(source_info[:file], '.*')} - "
        split_file source_info[:file], source_info[:cue], prefix

        source_info[:albums].each do |album|
          album[:tracks].collect! do |track|
            cue_track = format('%02d', track.delete(:cue_track))
            track[:path] = "#{prefix + cue_track}.flac"
            track_files << track[:path]
            track
          end
          albums << album
        end
      else
        source_info[:albums].each do |album|
          album[:tracks].collect! do |track|
            track[:path] = track[:file]
            track
          end
          albums << album
        end
      end
    end

    Success albums: albums, track_files: track_files
  end

  def process(albums:, track_files:, **)
    results = {}

    albums.each do |album_params|
      Rails.logger.debug "[albums_params] #{album_params}"
      result = ImportAlbum.new.(album_params)

      results.store album_params[:title],
                    result: result.success? ? 'success' : 'failure',
                    message: result.value!
    end

    FileUtils.rm_f track_files

    results
  end

  def split_file(file, cue_file, prefix)
    prefix = Shellwords.escape(prefix)
    cue_file = Shellwords.escape(cue_file)
    file = Shellwords.escape(file)

    exec_command_with_progress("shnsplit -f #{cue_file} -a #{prefix} -o flac -O always #{file}")

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
