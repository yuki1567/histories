# データベース設計

## users テーブル

| Column             | Type    | Options                     |
| ------------------ | ------- | --------------------------- |
| email              | string  | null: false, unique: true   |
| encrypted_password | string  | null: false                 |
| name               | string  | null: false                 | 
| kana_name          | string  | null: false                 |
| admin              | boolean | null: false, default: false |

### Association

- has_one :cart, dependent: :destroy
- has_many :borrows, dependent: :destroy

## books テーブル

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| title       | string     | null: false                    |
| author      | string     | null: false                    |
| content     | text       | null: false                    |
| quantity    | integer    | null: false                    |
| category_id | integer    | null: false                    |

### Association

- has_many :cart_boos
- has_many :carts, through: :cart_books
- has_many :borrow_books
- has_many :borrows, through: :borrow_books
- has_many :comments, dependent: :destroy

### borrows テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| borrowing_book | boolean    | null: false, default: true     |
| user           | references | null: false, foreign_key: true |

### Association 

- belongs_to :user
- has_many :borrow_books, dependent: :destroy
- has_many :books, through: :borrow_books
- has_one :address

## borrow_books テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| book   | references | null: false, foreign_key: true |
| borrow | references | null: false, foreign_key: true |

### Association

- belongs_to :book
- belongs_to :borrow

## addresses テーブル

| Column         | Type       | Options                        |
| -------------- | ---------- | ------------------------------ |
| postal_code    | string     | null: false                    |
| prefecture_id  | integer    | null: false                    |
| city           | string     | null: false                    |
| street_address | string     | null: false                    |
| detail_address | string     |                                |
| phone_number   | string     | null: false                    |
| borrow         | references | null: false, foreign_key: true |

### Association

- belongs_to :borrow

## carts テーブル

| Column   | Type       | Options                        |
| -------- | ---------- | ------------------------------ |
| quantity | integer    | null: false, default: 0        |
| user     | references | null: false, foreign_key: true |

### Association

- belongs_to :user
- has_many :cart_books, dependent: :destroy
- has_many :books, through: :cart_books

## cart_books テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| cart   | references | null: false, foreign_key: true |
| book   | references | null: false, foreign_key: true |

### Association

- belongs_to :cart
- belongs_to :book

## comments テーブル

| Column | Type       | Options                        |
| ------ | ---------- | ------------------------------ |
| text   | text       |                                |
| book   | references | null: false, foreign_key: true |

### Association

- belongs_to :book