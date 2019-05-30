class Book < ActiveRecord::Base
  has_many :checkouts
  has_many :users, through: :checkouts

  def self.most_popular
    self.all.max_by do |book|
      book.users.count
    end
    # binding.pry
  end

  def self.random_book
    self.all.sample
  end

  # find the longest book based on page_count

  # read book description (would have to add book description as column)

end
