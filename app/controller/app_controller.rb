class ApplicationController

  def run
    system "clear"
    display_bookworm
    welcome
  end

  def menu
    puts "What would you like to do?"
    puts "1. Search"
    puts "2. View your checkouts"
    puts "3. Return Book"
    puts "4. Return all Books"
    puts "5. Choose a random book for me"
    puts "6. Exit"
    task = gets.chomp
    action(task)
  end

  def welcome
    puts "Welcome to BookWorm!".colorize(:color => :red, :background => :white)
    puts "What is your name?".colorize(:green)
    name = gets.chomp.downcase
    if User.find_by(name: name)
      @current_user = User.find_by(name: name)
      system "clear"
      puts "Welcome back #{name}!"
    else
      @current_user = User.create(name: name)
      system "clear"
      puts "Welcome to BookWorm #{name}!"
    end
    menu
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
         system "clear"
         puts "You have successfully returned #{returned_book}.".colorize(:green)
         menu
        end
      when "4"
        if @current_user.books.empty?
          puts "You have no books checked out".colorize(:red)
          menu
        else
          @current_user.return_all
          system "clear"
          puts "You have successfully returned all your books!".colorize(:green)
          menu
        end
      when "5"
        random_book = random_search[0]
        show_book(random_book)
        new_book = Book.create_book(random_book)
        confirm_checkout(new_book)
      when "6"
        system "clear"
        puts "See you later #{@current_user.name}!".colorize(:green)
        exit
      else
        puts "Please enter one of the above index numbers".colorize(:red)
        menu
    end
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
    when -> result { result.downcase == "yes" || result.downcase == "y" }
      puts "Please have a look at the list of search results above and select index number of book you would like to checkout (1-10)".colorize(:green)
      index = gets.chomp.to_i
      if !index.between?(1, 10)
        puts "Please enter a number between 1 and 10".colorize(:red)
        index = gets.chomp.to_i
      end
      book = find_book_by_index(index)
      checkout_option(book)
    when -> result { result.downcase == "no" || result.downcase == "n" }
      puts "Please be more specific in your search!".colorize(:green)
      search_for_book_option
    else
      puts "Please enter valid input".colorize(:red)
      confirm_search
    end
  end

  def checkout_option(book)
    book_record = Book.find_by(title: book[:title])
    if book_record && !book_record.available
      unavailable_book = Book.find_by(title: book[:title])
      puts "Sorry! This book is checked out until #{book_record.checkouts[0].return_date}".colorize(:red)
      menu
    elsif book_record && book_record.available
      Checkout.checkout(@current_user, book_record)
      menu
    else
      book_row = Book.create_book(book)
      confirm_checkout(book_row)
    end
  end

  def confirm_checkout(book)
    puts "This Book is available to checkout! Would you like to check it out? (Y/n)".colorize(:green)
    input = gets.chomp
    case input
    when -> result { result.downcase == "yes" || result.downcase == "y" }
      Checkout.checkout(@current_user, book)
      menu
    when -> result { result.downcase == "no" || result.downcase == "n" }
      menu
    else
      puts "Please enter valid input".colorize(:red)
      confirm_checkout(book)
    end
  end

  def all_checkouts
    books = @current_user.reload.books
    books.each_with_index do |book, index|
      new_index = index + 1
      book.update(index: new_index)
      puts "Book index: #{new_index}"
      show_book(book)
      puts "  Checkout date: #{book.checkouts[0].checkout_date}"
      if (book.checkouts[0].return_date < DateTime.now)
        puts "  This Book is overdue! Please return as soon as possible".red
      else
        puts "  Return date: #{book.checkouts[0].return_date}"
        puts "--------------"
      end
    end
  end

  def show_book(book)
    puts "Title: #{book[:title]}".colorize(:light_blue)
    puts "  Author: #{book[:author]}"
    puts "  Category: #{book[:category]}"
    puts "  Page Count: #{book[:page_count]}"
  end

end
