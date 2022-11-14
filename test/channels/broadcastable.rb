require 'test_helper'

class TurboClone::BroadcastableTest < ActionCable::Channel::TestCase
  #gives access to the turbo_stream_action_tag
  #we can then use it in our tests to return html
  include TurboClone::ActionHelper

  test "#broadcast_append_to" do
    article = Article.create! content: "Something"

    #assert that the result of broadcast_on [:name_of_channel], is this html compared with what
    #is returned from the block  below
    assert_broadcast_on "stream", turbo_stream_action_tag(:append, target: "articles", template: render(article)) do
      article.broadcast_append_to "stream"
    end
  end

  test "#broadcast_prepend_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream", turbo_stream_action_tag(:prepend, target: "board_articles", template: render(article)) do
      article.broadcast_prepend_to "stream", target: "board_articles"
    end
  end

  test "#broadcast_remove_to" do
    article = Article.create! content: "Something"

    assert_broadcast_on "stream", turbo_stream_action_tag(:remove, target: article, template: nil) do
      article.broadcast_prepend_to "stream", target: article
    end
  end
end