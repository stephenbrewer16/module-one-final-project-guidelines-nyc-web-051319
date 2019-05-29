require_relative '../config/environment'
require 'rest-client'
require 'JSON'
require 'pry'

# current_user

def run
  welcome
  # grab_book_info
end

def list
  puts "1. Search"
  puts "2. View your checkouts"
  puts "3. Exit"
  task = gets.chomp
  action(task)
end

def welcome
  puts "Welcome to BookWorm!"
  puts "What is your name?"
  name = gets.chomp
  # current_user = User.find_or_create_by(name)
  puts "Hello #{name}!"
  puts "What would you like to do?"
  list
end

def action(input)
  case input
    when "1"
      puts "What book are you looking for?"
      book_query = gets.chomp
      book = search_for_book(book_query)
      puts "This Book is available to checkout! Would you like to check it out? [y,n]"
      input = gets.chomp
      case input
      when "y"
        # checkout(current_user, book)
      when "n"
        list
      end
    when "2"
      # books = current_user.books_checked_out
      books.each do |book|
        show_book(book)
        puts "-----------"
      end
      list
    when "3"
      exit
  end
end

# def most_popular
#   Book.all.max
# end
def find_book_in_api(book)
  query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{book}")
  string = query.body
  result = JSON.parse(string)
  titles = result["items"]
  titles.each do |book|
    title = book["volumeInfo"]["title"]
    puts title
    author = book["volumeInfo"]["authors"].join(" & ")
    puts author
    category = book["volumeInfo"]["categories"].join(" ")
    puts category
    page_count = book["volumeInfo"]["pageCount"].to_i
    puts page_count
  end
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
  # binding.pry
  puts "Title: #{book.title}"
  puts "  Author: #{book.author}"
  puts "  Category: #{book.category}"
  puts "  Page Count: #{book.page_count}"
end

def grab_book_info(book)
  # binding.pry
  books = book["items"]
  book_hash = {}
  books.each do |book|
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
