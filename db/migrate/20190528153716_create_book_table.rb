class CreateBookTable < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :category
      t.integer :page_count
    end
  end
end
