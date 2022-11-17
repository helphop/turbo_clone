module TurboClone::StreamsHelper

  def turbo_stream
    #self that is passed into this method is the view object
    TurboClone::Streams::TagBuilder.new(self)
  end

  def turbo_stream_from(*streamables, **attributes)
    attributes[:channel] = "TurboClone::StreamsChannel"
    attributes[:"signed-stream-name"] = TurboClone::StreamsChannel.signed_stream_name(streamables)
    tag.turbo_cable_stream_source(**attributes)
  end
end