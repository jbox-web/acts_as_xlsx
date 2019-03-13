class Comment < ApplicationRecord
  acts_as_xlsx
  belongs_to :post
  belongs_to :author
end
