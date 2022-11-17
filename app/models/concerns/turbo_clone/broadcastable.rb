module TurboClone::Broadcastable
  extend ActiveSupport::Concern

  class_methods do
    #returns the model name pluralized to use as a target
    #we must have this as a class method as we can't access it using
    #an instance
    def broadcast_target_default
      model_name.plural
    end
  end

  #* the list into an array or array into a list
  #** extracts contents of hash
  def broadcast_append_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_append_to(*streamables, target: target, **broadcast_rendering_with_defaults(rendering))
  end


  def broadcast_prepend_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_prepend_to(*streamables, target: target, **broadcast_rendering_with_defaults(rendering))
  end

  #We go by the requirement that we must use the model_name_id format
  #so we use self referring to the instance of the model which has an id
  #this is the default behavior. When calling this method from the model we can explicity
  #send a target value in
  def broadcast_replace_to(*streamables, target: self, **rendering)
    TurboClone::StreamsChannel.broadcast_replace_to(*streamables, target: target, **broadcast_rendering_with_defaults(rendering))
  end

  def broadcast_remove_to(*streamables, target: self)
    TurboClone::StreamsChannel.broadcast_remove_to(*streamables, target: target)
  end

  def broadcast_append_later_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_append_later_to(*streamables, target: target, **broadcast_rendering_with_defaults(rendering))
  end

  def broadcast_prepend_later_to(*streamables, target: broadcast_target_default, **rendering)
    TurboClone::StreamsChannel.broadcast_prepend_later_to(*streamables, target: target, **broadcast_rendering_with_defaults(rendering))
  end

  #here we want to use the target of the calling class itself so we can access the id and name to use
  def broadcast_replace_later_to(*streamables, target: self, **rendering)
    TurboClone::StreamsChannel.broadcast_replace_later_to(*streamables, target: target, **broadcast_rendering_with_defaults(rendering))
  end

  private

  def broadcast_rendering_with_defaults(rendering)
    rendering.tap do |r|
      # check if a locals key was passed. If not instantiate a hash and merge in the model_name.element.to_sym = article: article
      r[:locals] = (r[:locals] || {}).reverse_merge!(model_name.element.to_sym => self )
      r[:partial] ||= to_partial_path
    end
  end

  #used to delegate the instance method to the class method
  #need this as sometimes we need to access the class method
  #this gives more flexibility for the module
  #and this is how its done in the real gem
  def broadcast_target_default
    self.class.broadcast_target_default
  end
end