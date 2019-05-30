class Book < ActiveRecord::Base
  has_many :checkouts
  has_many :users, through: :checkouts

<<<<<<< HEAD
def random_book
  find(:all).sample(5)
end
  # book rating property
=======
>>>>>>> 7495a7418c3500259baae362d38c78e669aaf9cc

  def self.most_popular
    self.all.max_by do |book|
      book.users.count
    end
    # binding.pry
  end

  # find the longest book based on page_count

  # read book description (would have to add book description as column)

end
