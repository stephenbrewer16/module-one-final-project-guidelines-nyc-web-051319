class Book < ActiveRecord::Base
  has_many :checkout
  has_many :users, through: :checkout

  
end
