require_relative '../config/environment'
require 'rest-client'
require 'JSON'
require 'pry'

def run
  welcome
  # grab_book_info
end

def welcome
  puts "Welcome to BookWorm!"
  puts "What is your name?"
  name = gets.chomp
  create_or_find_user(name)
  puts "Hello #{name}!"
  puts "What would you like to do?"
  task = gets.chomp
  action(task)
end

def action(input)
  # case input
  if input == "1"
    puts "What book would you like to checkout?"
      book_query = gets.chomp
    search_for_book(book_query)
  end
end

def create_or_find_user(name)
  User.find_or_create_by(name: name)
end

# def most_popular
#   Book.all.max
# end
def find_book_in_api(book)
  query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{book}")
  result = JSON.parse(query)
  if result["totalItems"] == 0
    puts "Sorry :( We have no record of this book. Please try again..."
  else
    book_hash = grab_book_info(result)
    create_book(book_hash)
    # show_book(book)
  end
end

def search_for_book(book)
  if Book.find_by(title: book) == nil
    find_book_in_api(book)
  else Book.find_by(title: book)
    show_book(book)
  end
end

def show_book(book)
  Book.find_by(title: book)
  # puts " "
end

def grab_book_info(book)
  # binding.pry
  books = book["items"]
  book_hash = {}
  books.find do |book|
    book_hash[:title] = book["volumeInfo"]["title"]
    book_hash[:author] = book["volumeInfo"]["authors"].join(" & ")
    book_hash[:category] = book["volumeInfo"]["categories"].join(" ")
    book_hash[:page_count] = book["volumeInfo"]["pageCount"].to_i
  end
  book_hash
end

def create_book(book_hash)
  Book.create(book_hash)
end

def checkout(user, book)
  Checkout.create(user_id: user.id, book_id: book.id)
end

run
# puts most_popuar
# add_to_wishlist("mendel", "Harry Potter and the Cursed Child – Parts One and Two (Special Rehearsal Edition)")
# puts "HELLO WORLD"
