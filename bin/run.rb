require_relative '../config/environment'
require 'rest-client'
require 'JSON'
require 'pry'

# current_user
# display_bookworm


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
  @current_user = User.find_or_create_by(name: name)
  puts "Hello #{name}!"
  puts "What would you like to do?"
  list
end

def display_bookworm
  puts  "               (o)(o)          "
  puts  "              /     \\         "
  puts  "             /       |         "
  puts  "            /   /\\   |        "
  puts  "        ___/___/__\\__/        "
  puts  "      _/      Y      \\_       "
  puts  "     // ~~ ~~ | ~~ ~  \\\\     "
  puts  "    // ~ ~ ~~ | ~~~ ~~ \\\\    "
  puts  "   //________.|.________\\\\   "
  puts  "  '----------'-'----------'    "
end

def search_for_book_option
  puts "What book are you looking for?"
  book_query = gets.chomp
  book = search_for_book(book_query)
  confirm_search
end

def confirm_search
  puts "Did you find the book you are searching for? [y,n]"
  input = gets.chomp
  case input
  when "y"
    puts "Please select index of book you would like to checkout (1-10)"
    index = gets.chomp
    find_book_by_index(index)
    binding.pry
    checkout_option(index)
  when "n"
    puts "Please be more specific in your search"
    search_for_book_option
  end
end

def find_book_by_index(index)
  @book_hashes.find do |book|
    book[:index] == index
      book
  end
end

def action(input)
  case input
    when "1"
      search_for_book_option
    when "2"
      books = @current_user.books_checked_out
      books.each do |book|
        show_book(book)
        puts "-----------"
      end
      list
    when "3"
      exit
    end
end

def checkout_option(index)

  create_book(index)
  puts "This Book is available to checkout! Would you like to check it out? [y,n]"
  input = gets.chomp
  case input
  when "y"
    checkout(@current_user, book)
  when "n"
    list
  end
end

def find_book_in_api(book)
  query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{book}")
  result = JSON.parse(query)
  books = result["items"]
  if result["totalItems"] == 0
    puts "Sorry :( We have no record of this book. Please try again..."
  else
    @book_hashes = []
    book_result = books.each_with_index do |book, index|
      new_index = index + 1
      puts "Book index: #{new_index}"
      book_hash = grab_book_info(book, new_index)
      @book_hashes << book_hash
      show_book(book_hash)
      puts "-----------"
    end
  end
end

def search_for_book(book_query)
  if Book.find_by(title: book_query) == nil
    find_book_in_api(book_query)
  else
    book = Book.find_by(title: book_query)
    show_book(book)
  end
end

def show_book(book)
  puts "Title: #{book[:title]}"
  puts "  Author: #{book[:author]}"
  puts "  Category: #{book[:category]}"
  puts "  Page Count: #{book[:page_count]}"
end

def grab_book_info(book, index)
  book_hash = {}
  book_hash[:index] = index
  title = book["volumeInfo"]["title"]
  author = book["volumeInfo"]["authors"]
  category = book["volumeInfo"]["categories"]
  page_count = book["volumeInfo"]["pageCount"].to_i
  if author
    book_hash[:author] = author.join(" & ")
  else
    book_hash[:author] = "No author for this book"
  end

  if category
    book_hash[:category] = category.join(" ")
  else
    book_hash[:category] = "No category defined for this book"
  end

  book_hash[:title] = title
  book_hash[:page_count] = page_count
  book_hash
end

def create_book(book_hash)
  Book.create(book_hash)
end

def checkout(current_user, book)
  binding.pry
  Checkout.create(user_id: current_user.id, book_id: book.id)
end


run
# puts most_popuar
# add_to_wishlist("mendel", "Harry Potter and the Cursed Child – Parts One and Two (Special Rehearsal Edition)")
# puts "HELLO WORLD"
