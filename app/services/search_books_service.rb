class SearchBooksService
  def self.search(search)
    if search != ''
      book = Book.where('title LIKE(?) OR author LIKE(?)', "%#{search}%", "%#{search}%")
    else
      Book.all
    end
  end
end
