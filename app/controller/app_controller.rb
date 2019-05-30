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
      puts "Welcome back #{name}!"
    else
      @current_user = User.create(name: name)
      puts "Welcome to BookWorm #{name}!"
    end
    menu
  end


  def display_bookworm

puts "
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXKKKKXNWMMXkdddddxxxdodKWWKkxkkkxxkkxxkKNMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNK0xxxxxkkxxxxkxlo0XXXXNNXNKdldddkOKKXXXXKKOkxdkNMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXxddxO0KXXXXXXK0kocd0XXXXXXXNXx:o0KKXNNWWWWWNXKK0do0W
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOoxKKKKXNWWWMWWNXXK0xlkXNXXXXXkoOXKXWMMMMMMMMMMWXKKOok
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWko0XKKXWMMMMMMMMMMWNKKOoxXXXKXOlkXKNMMMMMMWX000XWMNKKkl
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0oOXKNMMMMMMMWKkxk0NWNKKkclxxxxloKKKWMMMMWOc....'l0WXKKl
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWdoXKKWMMMMMW0c.   .,xNXKXOdxxxxx0NKXMMMMWO'       ;0XKXo
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWdoXKXMMMMMMK,       .xXKXkoxkkkodKXKWMMMWx. ,l:.  .kKK0l
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWkoKXKNMMMMM0,  .lOd'.d0KOlxXXXNKodXKKNMMMXl,dXO, .o0KKdo
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXddKXKXNMMMWk;..lkdcoOKKooKXXXXX0odKXKXNWMN0xxdlok0XKddK
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXdo0XKKKNWMMXOdddxk0KOc:dxxkkkkkdccx0KXXXXXXXXXXK0xokNM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx:lxkOKXXXXXXXXXXKOdloxOkkOKKkoxOOxddxkOO00Okkxdo:xWMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKlxKkddxxkkkOOkkkxddOKXN0c.c0Kl.:OXXXKOkxxkkxxkOKKooXMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMOlONXXXK0kdodxxkk0KXXXXXKkokKX0O0XXXXXNXXNN00XNXXXxoKMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMOlONXXXXXNOokXXXNXXXXXXXXXNXNNNXXXXXXXXXXXKooKXXX0lxWMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXodKXNXXNXKxlxKXXXXXXXXXXXXXXXXXXXXXNNXXKOdoOXXX0odXMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKod0XXXXXXXOdodxO0KXXXXXXXXXXXXK00OOxxdddkKXX0dlxNMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkoodOKXXXXXKOo;:loooooollodxxxddxxxk0KXXKkdoxKWMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKOxddxOKXXXk:lxddddol;lOKKXXXXXXXKOkxddxONMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWWN0dlcoxkOl:dxxxdlcdKXXXXX0doxxxkk0XWMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKo:coxdcclxO0X0ocllcloOXNXXXXXO:lKNWMMMMMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOl.......,:lxO0XX0kxkKXNNNXXXK0d:cOWNXKXWMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWxlo,.........,:oxk0KXXXXXK0Okxolll;,c:,'cKMMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKcok, ...........,:cloooddocccc:;;,......,0MMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXookdc:cc;................'..............';dNMMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0lxOdddddo;..........  .  ...............:dlxNMMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKlxOdodddoc..........  .  ...........,clllxklkWMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMWX0OkkkkOO0XWMMMMMNklddddddl'.......... ..  ...........cxxddk0ooNMMMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMWXkddxxkOOOkxxxxxk0NWMWOc;;;;;,........... .. ...........'cdxddkOloNMMMMMMMMM
MMMMWXKKNWMMMMMMMMMMMWXxoxOXXXXXXNNXXXKOxdxxxxddxc'.............. .. ............'cddddodKMMMMMMMMMM
MWXkdxxxoxXMMMMMMMMMNkld0XXXXNNXXXXXXXXXNXXK00KXXo'.............. .. .............'lxxk0NMMMMMMMMMMM
Nkld0XXKol0MMMMMMMMXdoOXXXXXXXXXXXXXXNNNXNNXNXXXXd;.............  .  .............;KMMMMMMMMMMMMMMMM
xlOXX0xoxKWMMMMMMW0odKXXNXXX0kxxxxxddk0XXXXXXXXXXkl;............ ..  .............dWMMMMMMMMMMMMMMMM
ckXXOldXWMMMMMMMNxlxKXXXKkdddkOKNNNX0xodOXXXXXXXXXX0o,.......... .. .............;0MMMMMMMMMMMMMMMMM
lKNXdoXMMMMMMMNOooOXXXOddxOXWMMMMMMMMMNkod0XXXXXXXXXXKxc,'.....  .  ..........':o0WMMMMMMMMMMMMMMMMM
c0NXxl0WMMMNKkodOXXKkodOXWMMMMMMMMMMMMMMXxlkXXXXXNNXXXXXKOxl,':c::;,;;,,',;:lx0NMMMMMMMMMMMMMMMMMMMM
loKNKxddxxxxdx0XX0xox0WMMMMMMMMMMMMMMMMMMW0dox0XXXNNXXXKOxddkKWWWWWNNNXXKXNWWMMMMMMMMMMMMMMMMMMMMMMM
KdoOXXX0OO0KXXXOdoxKWMMMMMMMMMMMMMMMMMMMMMMWKkxxxxxxxxxxxkKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MNkodk0KXKK0kxddkXMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXKKKKXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
MMMXxcclcllcld0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
".green.on_black
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
          puts "You have successfully returned all your books!"
          menu
        end
      when "5"
        random_book = random_search[0]
        show_book(random_book)
        new_book = create_book(random_book)
        confirm_checkout(new_book)
      when "6"
        puts "See you later #{@current_user.name}!".colorize(:green)
        exit
    end
  end

  def all_checkouts
    novels = @current_user.reload.books
    novels.each_with_index do |book, index|
      new_index = index + 1
      book.update(index: new_index)
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
      confirm_checkout(book_row)
    end
  end

  def confirm_checkout(book)
    puts "This Book is available to checkout! Would you like to check it out? (Y/n)".colorize(:green)
    input = gets.chomp
    case input
    when -> result { result.downcase == "yes" || result.downcase == "y" }
      checkout(@current_user, book)
      menu
    when -> result { result.downcase == "no" || result.downcase == "n" }
      menu
    else
      puts "Please enter valid input".colorize(:red)
      confirm_checkout(book)
    end
  end

  def search_for_book(book)
    query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{book}")
    result = JSON.parse(query)
    books = result["items"]
    if result["totalItems"] == 0
      puts "Sorry :( We have no record of this book. Please try again...".colorize(:red)
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
    puts "Title: #{book[:title]}".colorize(:light_blue)
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

    if title
      book_hash[:title] = title
    else
      book_hash[:title] = "No title defined for this book"
    end
    book_hash[:page_count] = page_count
    book_hash
  end

  def create_book(book_hash)
    new_book = Book.create(book_hash)
    new_book.update(available: true)
    new_book
  end

  def checkout(current_user, book)
    checked_book = Checkout.create(user_id: current_user.id, book_id: book.id, checkout_date: DateTime.now, return_date: DateTime.now + 7)
    checked_book.book.update(available: false)
    puts "You now have #{book.title} checked out!".colorize(:color => :purple, :background => :green)
  end

  def random_search
    random_letter = ('a'..'z').to_a.sample
    query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{random_letter}")
    result = JSON.parse(query)
    books = result["items"]
    @book_hashes = []
    book_result = books.each_with_index do |book, index|
      new_index = index + 1
      book_hash = grab_book_info(book, new_index)
      @book_hashes << book_hash
    end
    @book_hashes
  end

end
