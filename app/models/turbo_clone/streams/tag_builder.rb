class TurboClone::Streams::TagBuilder
  include TurboClone::ActionHelper

  def initialize(view_context)
    @view_context = view_context
    #The .formats method is complex and requires this code
    @view_context.formats |= [:html]
  end

  # ** signifies the optional passing of a hash object
  def replace(target, content = nil, **rendering, &block)
    action(:replace, target, content, **rendering, &block)
  end

  def update(target, content = nil, **rendering, &block)
    action(:update, target, content, **rendering, &block)
  end

  def prepend(target, content = nil, **rendering, &block)
    action(:prepend, target, content, **rendering, &block)
  end

  def remove(target, content = nil, **rendering, &block)
    action(:remove, target)
  end

  private

  def action(name, target, content = nil,**rendering, &block)
    #render html that goes inside the template tags
    template = render_template(target, content, **rendering, &block) unless name == :remove

    #render the entire html wrapper turbo-stream wrpper code
    turbo_stream_action_tag(name, target: target, template: template)
  end

  #with the view context object we can render the same way
  #we would in a view using <%= render ... %>
  def render_template(target, content = nil, **rendering, &block)
    if content
      content.respond_to?(:to_partial_path) ? @view_context.render(partial: content, formats: :html) : content
    elsif block_given?
      @view_context.capture(&block)
    elsif rendering.any?
      # we use **rendering an NOT rendering so that we
      # merge the formats: :html into the **rendering hash
      @view_context.render(**rendering, formats: :html)
    else
      @view_context.render(partial: target, formats: :html)
    end
  end
end