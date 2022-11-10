module TurboClone::Broadcastable
  extend ActiveSupport::Concern

  class_methods do
    def broadcast_target_default
      model_name.plural
    end
  end
  #here the star converts the list into an array
  def broadcast_append_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_append_to(*streamables, target: target, **broadcast_rendering_with_defaults(rendering))
  end

  private

  def broadcast_rendering_with_defaults(rendering)
    rendering.tap do |r|
      # check if a locals key was passed. If not instantiate a hash and merge in the model_name.element.to_sym = article: article
      r[:locals] = (r[:locals] || {}).reverse_merge!(model_name.element.to_sym => self )
      r[:partial] ||= to_partial_path
    end
  end

  #can access this method using model_instance.senc(:broadcast_target_default)
  #But we really shouldn't need to access this method.  It's a private method for a reason.
  def broadcast_target_default
    self.class.broadcast_target_default
  end
end