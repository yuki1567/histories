crumb :root do
  link '<i class="bi bi-book"></i>HISTORIES'.html_safe, root_path 
end

crumb :search do |category|
  if params[:q][:category_id_eq]
    category = Category.find(params[:q][:category_id_eq])
    link "#{category.name}", search_books_path
    parent :root, category
  else
    link "#{params[:q][:title_or_author_cont]}", search_books_path
    parent :root
  end
end

crumb :book do |book|
  link "#{book.title}", book_path(book)
  parent :root
end

crumb :edit_book do |book|
  link "本情報編集", edit_book_path(book)
  parent :book, book
end

crumb :cart do
  link "カート", user_cart_path(current_user, current_user.cart)
  parent :root
end

crumb :new_borrow do |user|
  link "住所入力", new_user_borrow_path(user)
  parent :cart
end

crumb :user do |user|
  link "#{user.name}さん", user_path(user)
  parent :root
end

crumb :borrows do |user|
  link "借りた本の履歴", user_borrows_path(user)
  parent :user, user
end

crumb :edit_user do |user|
  link "ユーザー情報編集", edit_user_path(user)
  parent :user, user
end





