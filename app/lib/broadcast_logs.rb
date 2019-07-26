require 'open3'

module BroadcastLogs
  def exec_command_with_progress(command)
    Open3.popen2e(command) do |_i, o, _t|
      prev_char = ''
      str = ''
      bs_count = 0

      while (char = o.getc) do
        puts char

        case char
        when "\n"
          broadcast_string str
          str.clear
        when "\b"
          bs_count += 1
        else
          if char != "\b" && prev_char == "\b"
            prog_str = str.slice!(-bs_count..-1)[/\d+/]
            broadcast_progress(prog_str) if prog_str.end_with?('0')
            bs_count = 0

            if str != ''
              broadcast_string str
              str.clear
            end
          end

          str << char
        end

        prev_char = char
      end
    end
  end

  def broadcast_string(string)
    ActionCable.server.broadcast('logs', {string: string})
  end

  def broadcast_progress(progress)
    ActionCable.server.broadcast('logs', {progress: progress})
  end
end