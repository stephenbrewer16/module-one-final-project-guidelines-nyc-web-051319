class ApplicationController

  def run
    welcome
  end

  def list
    puts "What would you like to do?"
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
      index = gets.chomp.to_i
      book = find_book_by_index(index)
      checkout_option(book)
    when "n"
      puts "Please be more specific in your search!"
      search_for_book_option
    end
  end

  def find_book_by_index(index)
    @book_hashes.find do |book|
      if book[:index] == index
        book
      end
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
          puts "Checkout date: #{book.checkout[0].checkout_date}"
          puts "Return date: #{book.checkout[0].return_date}"
          puts "-----------"
        end
        list
      when "3"
        exit
      end
  end

  def checkout_option(book)
    if Book.find_by(title: book[:title])
      puts "Sorry! This book is checked out."
    else
      book_row = create_book(book)
      puts "This Book is available to checkout! Would you like to check it out? [y,n]"
      input = gets.chomp
      case input
      when "y"
        checkout(@current_user, book_row)
      when "n"
        list
      end
    end
  end

  def search_for_book(book)
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
    Checkout.create(user_id: current_user.id, book_id: book.id, checkout_date: DateTime.now, return_date: DateTime.now + 7 )
    puts "You now have #{book.title} checked out!"
    list
  end

end
