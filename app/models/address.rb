class Address < ApplicationRecord
  belongs_to :borrow
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :Prefecture
end
