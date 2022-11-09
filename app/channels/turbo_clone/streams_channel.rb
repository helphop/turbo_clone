class TurboClone::StreamsChannel < ActionCable::Channel::Base
  extend TurboClone::Streams::StreamsName

  def subscribed
    stream_from params[:signed_stream_name]
  end
end
