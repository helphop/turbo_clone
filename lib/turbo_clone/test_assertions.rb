module TurboClone::TestAssertions
  extend ActiveSupport::Concern

  #Rails syntactic sugar for more complex Ruby code
  #when this module is included in some class
  #the following code is run
  #Similar to has_many or validates methods on Rails model classes
  included do
    delegate :dom_id, to: ActionView::RecordIdentifier
  end

  def assert_turbo_stream(action:, target: nil, status: :ok)
    #always check these two things
    assert_response status
    assert_equal Mime[:turbo_stream], response.media_type

    selector = %(turbo-stream[action="#{action}"])
    #must add the target after in case there is no target
    selector << %([target="#{dom_id_or_target(target)}"]) if target
    assert_select selector, count: 1
  end

  private

  def dom_id_or_target(target)
    target.respond_to?(:to_key) ? dom_id(target) : target
  end
end