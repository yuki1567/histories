class CreateBorrows < ActiveRecord::Migration[6.0]
  def change
    create_table :borrows do |t|
      t.boolean    :borrowing_book, null: false, default: true
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
