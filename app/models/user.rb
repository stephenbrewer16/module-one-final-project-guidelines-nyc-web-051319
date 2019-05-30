class User < ActiveRecord::Base
  has_many :checkouts
  has_many :books, through: :checkouts

<<<<<<< HEAD
  # add book rating method

  # count how many books he has checked out

  # find the books that are overdue

=======
>>>>>>> 7495a7418c3500259baae362d38c78e669aaf9cc
  def return_book(index)
     checkouts[index - 1].book.update(available: true)
     returned_book = checkouts[index - 1].book.title
     self.books.delete(books[index - 1])
     returned_book
   end

   def return_all
      self.books.each do |book|
        book.update(available: true)
        self.books.delete_all
      end
    end

end
