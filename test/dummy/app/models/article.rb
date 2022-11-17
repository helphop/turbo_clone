class Article < ApplicationRecord
  validates :content, presence: true

  #these are instance methods
  #called when something happens on an instance
  # after_create_commit { broadcast_append_later_to "articles" }
  after_create_commit { broadcast_prepend_later_to "articles" }
  after_update_commit { broadcast_replace_later_to "articles" }
  after_destroy_commit { broadcast_remove_to "articles" }

end
