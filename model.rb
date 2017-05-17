require_relative 'modules/associatable'
require 'pry'

class Book < SQLObject

  belongs_to :author, :foreign_key => :author_id
  belongs_to :genre, :foreign_key => :genre_id

  finalize!

end

class Author < SQLObject

  has_many :books, :foreign_key => :author_id

  finalize!

end

class Genre < SQLObject

  has_many :books, :foreign_key => :genre_id

  finalize!

end


binding.pry
