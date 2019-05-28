class CreateCheckoutTable < ActiveRecord::Migration[5.0]
  def change
    create_table :checkouts do |t|
      t.integer :user_id
      t.integer :book_id
      t.datetime :checkout_date
      t.datetime :return_date
    end
  end
end
