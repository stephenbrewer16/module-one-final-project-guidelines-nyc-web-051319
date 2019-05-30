class ApplicationController

  def run
    display_bookworm
    welcome
  end

  def menu
    puts "What would you like to do?"
    puts "1. Search"
    puts "2. View your checkouts"
    puts "3. Return Book"
    puts "4. Return all Books"
    puts "5. Logout"
    puts "6. Exit"
    puts "7. Overdue books"
    task = gets.chomp
    action(task)
  end

  def welcome
    puts "Welcome to BookWorm!"
    puts "What is your name?"
    name = gets.chomp
    if User.find_by(name: name.downcase)
      @current_user = User.find_by(name: name)
      puts "Welcome back #{name}!"
    else
      @current_user = User.create(name: name.downcase)
      puts "Welcome to BookWorm #{name}!"
    end
    menu
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
    puts "Did you find the book you are searching for? (Y/n)".colorize(:color => :blue, :background => :white)
    input = gets.chomp
    case input
    when "y"
      puts "Please have a look at the menu of search results above and select index number of book you would like to checkout (1-10)"
      index = gets.chomp.to_i
      book = find_book_by_index(index)
      checkout_option(book)
    when "n"
      puts "Please be more specific in your search!".colorize(:green)
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
        if @current_user.reload.books.empty?
          puts "You have no books checked out".colorize(:red)
        end
        all_checkouts
        menu
      when "3"
        if @current_user.reload.books.empty?
          puts "You have no books checked out".colorize(:red)
          menu
        else
         all_checkouts
         puts "Please select index of book you would like to return (1-#{@current_user.books.length})".colorize(:red)
         index = gets.chomp.to_i
         returned_book = @current_user.return_book(index)
         puts "You have successfully returned #{returned_book}.".colorize(:green)
         menu
        end
      when "4"
        if @current_user.books.empty?
          puts "You have no books checked out".colorize(:red)
          menu
        else
          @current_user.return_all
          menu
        end
      when "5"
        logout
      when "6"
        puts "See you later #{@current_user.name}!".colorize(:green)
        exit
      when "7"
        @current_user.overdue_books
      end
  end

  def all_checkouts
    # binding.pry
    novels = @current_user.reload.books
    novels.each_with_index do |book, index|
      new_index = index + 1
      # binding.pry
      book.update(index: new_index)
      # binding.pry
      puts "Book index: #{new_index}"
      show_book(book)
      puts "  Checkout date: #{book.checkouts[0].checkout_date}"
      puts "  Return date: #{book.checkouts[0].return_date}"
      puts "--------------"
    end
  end

  def checkout_option(book)
    book_record = Book.find_by(title: book[:title])
    if book_record && !book_record.available
      unavailable_book = Book.find_by(title: book[:title])
      puts "Sorry! This book is checked out until #{book_record.checkouts[0].return_date}".colorize(:red)
      menu
    elsif book_record && book_record.available
      checkout(@current_user, book_record)
      menu
    else
      book_row = create_book(book)
      puts "This Book is available to checkout! Would you like to check it out? (Y/n)".colorize(:green)
      input = gets.chomp
      case input
      when "y"
        checkout(@current_user, book_row)
        menu
      when "n"
        menu
      end
    end
  end

  def search_for_book(book)
    query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{book}")
    result = JSON.parse(query)
    books = result["items"]
    if result["totalItems"] == 0
      puts "Sorry :( We have no record of this book. Please try again..."
      search_for_book_option
    else
      @book_hashes = []
      book_result = books.each_with_index do |book, index|
        new_index = index + 1
        puts "Book index: #{new_index}"
        book_hash = grab_book_info(book, new_index)
        @book_hashes << book_hash
        show_book(book_hash)
        puts "--------------"
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
    # binding.pry
    checked_book = Checkout.create(user_id: current_user.id, book_id: book.id, checkout_date: DateTime.now, return_date: DateTime.now + 7)
    # binding.pry
    checked_book.book.update(available: false)
    puts "You now have #{book.title} checked out!".colorize(:color => :purple, :background => :green)
  end

  def logout
    puts "Thanks for visiting #{@current_user.name}!".colorize(:green)
    run
  end

end
