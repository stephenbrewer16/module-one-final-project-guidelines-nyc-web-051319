class User < ActiveRecord::Base
  has_many :checkouts
  has_many :books, through: :checkouts

  def books_checked_out
    self.books
  end

  def return_book(index)
    checkouts[index - 1].book.update(available: true)
    returned_book = checkouts[index - 1].book.title
    self.books.delete(books[index - 1])
    returned_book
  end
end
