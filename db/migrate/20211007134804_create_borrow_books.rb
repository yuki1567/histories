class CreateBorrowBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :borrow_books do |t|
      t.references :book, null: false, foreign_key: true
      t.references :borrow, null: false, foreign_key: true
      t.timestamps
    end
  end
end
