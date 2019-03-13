class Post < ApplicationRecord
  acts_as_xlsx
  has_many :comments

  def ranking
    a = Post.all.order(votes: :desc)
    a.index(self) + 1
  end

  def last_comment
    comments.last.content
  end
end
