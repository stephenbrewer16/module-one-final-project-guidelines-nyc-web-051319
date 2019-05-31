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

def find_book_by_index(index)
  @book_hashes.find do |book|
    if book[:index] == index
      book
    end
  end
end

def random_search
  query = RestClient.get("https://www.googleapis.com/books/v1/volumes?q=#{RandomWord.nouns.next}")
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
