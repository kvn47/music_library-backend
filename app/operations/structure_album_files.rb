require 'shellwords'

class StructureAlbumFiles < ATransaction
  step :collect_info
  tee :process

  private

  def collect_info(input)
    Import::CollectInfo.(input)
  end

  def process(path:, import_sources:, **)
    Dir.chdir path

    import_sources.each do |cue: nil, file:, albums:, **|
      if cue
        split_file file, cue

        albums.each do |album|

        end
      end
    end
  end

  def split_file(file, cue)
    cue = Shellwords.escape(cue)
    file = Shellwords.escape(file)
    `shnsplit -f #{cue} -t '%n. %t' -o flac -O always #{file}`

    # Creating tag metadata
    # `cuetag #{cue_file} #{prefix}*.flac`
  end
end
