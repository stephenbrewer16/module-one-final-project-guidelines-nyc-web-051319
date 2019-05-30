class Book < ActiveRecord::Base
  has_many :checkouts
  has_many :users, through: :checkouts

def random_book
  find(:all).sample(5)
end
  # book rating property

  # find book with highest rating/ or based on user input

  # find most popular book in the database with most checkouts (top 10 all time etc...)

  # find the longest book based on page_count

  # read book description (would have to add book description as column)

end
