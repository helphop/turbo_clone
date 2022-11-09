require "test_helper"

class TurboClone::StreamsControllerTest < ActionDispatch::IntegrationTest

  test "create with respond to" do
    #defaults to HTML request
    post articles_path, params: { article: { content: "something" } }
    assert_redirected_to articles_path

    #must specify :turbo_stream
    post articles_path, params: { article: { content: "something" } }, as: :turbo_stream
    assert_turbo_stream action: "prepend", target: "articles"
  end

  test "update with respond to" do
    article = Article.create! content: "something"

    #Use patch in Rails for updating an object
    #Again default format is HTML
    patch article_path(article), params: { article: {content: "something else" } }
    assert_redirected_to articles_path

    #Must specify :turbo_stream
    patch article_path(article), params: { article: {content: "something different" } }, as: :turbo_stream
    assert_turbo_stream action: "replace", target: article
  end

  test "destroy with respond to" do
    article = Article.create! content: "something"

    delete article_path(article)
    assert_redirected_to articles_path

    article = Article.create! content: "something else"

    delete article_path(article), as: :turbo_stream
    assert_turbo_stream action: "remove", target: article
  end

  test "show all turbo actions" do
    # skip 'not passing for now'
    article = Article.create! content: "something"
    get article_path(article), as: :turbo_stream

    assert_dom_equal <<~HTML, @response.body
      <turbo-stream action="remove" target="#{dom_id(article)}"></turbo-stream>
      <turbo-stream action="update" target="#{dom_id(article)}"><template>#{render(article)}</template></turbo-stream>
      <turbo-stream action="replace" target="#{dom_id(article)}"><template>Something else</template></turbo-stream>
      <turbo-stream action="prepend" target="articles"><template>#{render(article)}</template></turbo-stream>
      <turbo-stream action="prepend" target="articles"><template>#{render(article)}</template></turbo-stream>
    HTML
  end


end