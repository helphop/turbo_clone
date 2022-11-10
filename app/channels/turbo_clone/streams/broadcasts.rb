module TurboClone::Streams::Broadcasts
  include TurboClone::ActionHelper

  def broadcast_append_to(*streamables, **options)
    broadcast_action_to(*streamables, action: :append, **options)
  end

  #**rendering captures the partials and locals that are passed to the broadcast_append_to method
  #usually in the form of partial: 'articles/article', locals: { article: @article}
  #we know a lot about the **options variable since we use target: as a variable
  #and **rendering for everything else
  def broadcast_action_to(*streamables, action:, target: nil, **rendering)
    broadcast_stream_to *streamables, content: turbo_stream_action_tag(
      action, target: target, template: (rendering.any? ? render_format(:html, **rendering) : nil))
  end

  def broadcast_stream_to(*streamables, content:)
    ActionCable.server.broadcast stream_name_from(streamables), content
  end

  private

  #!? Ask about why we need the formats key since I can't find it in the API
  def render_format(format, **rendering)
    ApplicationController.render(formats: [format], **rendering)
  end
end