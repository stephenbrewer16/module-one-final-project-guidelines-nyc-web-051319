class Book < ActiveRecord::Base
  has_many :checkouts
  has_many :users, through: :checkouts


  def self.create_book(book_hash)
    new_book = self.create(book_hash)
    new_book.update(available: true)
    new_book
  end

end
