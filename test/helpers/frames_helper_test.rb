require "test_helper"

class TurboClone::FramesHelperTest < ActionView::TestCase

  test "frame with a model" do
    article = Article.new id: 1, content: "not important"

    assert_dom_equal %[<turbo-frame id="article_1"></turbo-frame>], turbo_frame_tag(article)
  end

  test "frame with a string" do
    assert_dom_equal %[<turbo-frame id="new_article"></turbo-frame>], turbo_frame_tag(Article.new)
  end

  test "frame with a block" do
    article = Article.new id: 1, content: "not important"

    assert_dom_equal %[<turbo-frame id="article_1"><p>hey</p></turbo-frame>],
      turbo_frame_tag(article) { tag.p "hey"}
  end

end