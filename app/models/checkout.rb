class Checkout < ActiveRecord::Base
  belongs_to :user
  belongs_to :book


  def self.checkout(current_user, book)
    new_checkout = Checkout.create(user_id: current_user.id, book_id: book.id, checkout_date: DateTime.now, return_date: DateTime.now + 7)
    new_checkout.book.update(available: false)
    system "clear"
    puts "You now have #{book.title} checked out!".colorize(:color => :purple, :background => :green)
  end

end
