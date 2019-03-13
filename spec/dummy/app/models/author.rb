class Author < ApplicationRecord
  acts_as_xlsx
  has_many :comments
end
