require_relative '../config/environment'
require 'rest-client'
require 'JSON'

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
end

def create_or_find_user(name)
  User.find_or_create_by(name: name)
end

def search_for_book
  input = gets.chomp
  query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{input}")
  result = JSON.parse(query)
end


def grab_book_info
  data = search_for_book
  books = data["items"]
  book_hash = {}
  books.find do |book|
    book_hash[:title] = book["volumeInfo"]["title"]
    book_hash[:author] = book["volumeInfo"]["authors"].join(" & ")
    book_hash[:category] = book["volumeInfo"]["categories"].join(" ")
    book_hash[:page_count] = book["volumeInfo"]["pageCount"].to_i
  end
  book_hash
end

def create_book
  book_hash = grab_book_info
  Book.create(book_hash)
end



run
# puts "HELLO WORLD"
