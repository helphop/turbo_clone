module TurboClone::Streams::StreamsName
    #Notice the we do not use self. To make this a class method
    #since class or modules will use **extend** to use it
    #Example in the streams_channel.rb file

  def stream_name_from(streamables)
    puts self
    if streamables.is_a?(Array)
      streamables.map { |streamable| stream_name_from(streamable)}.join(":")
    else
      #this just makes streamables act like an enumberable
      #so streamable is the same object as streamables
      #just makes the code easier to understand
      streamables.then do |streamable|
        streamable.respond_to?(:to_key) ? ActionView::RecordIdentifier.dom_id(streamable) : streamable
      end
    end
  end
end