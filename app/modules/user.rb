class User < ActiveRecord::Base
  has_many :checkouts
  has_many :books, through: :checkouts

  def books_checked_out
    self.books
  end
end
