class LogsChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'logs'
  end
end
