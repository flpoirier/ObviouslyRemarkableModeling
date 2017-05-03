# building a database:
#
# create a .sql file, run "cat import <file_name>.sql | sqlite3 <file_name>.db" in the terminal
#
# to create a ruby-manipulable database:
#
# require 'sqlite3' gem
# whatever_db = SQLite3::Database.new('./<file_name>.db')
#
# to query database using ruby:
#
# whatever_db.execute("SELECT * FROM whatever")
#
# about object relational mapping:
#
# basically a way to take raw data and turn it into manipulable objects in the language of your choice
#
# ORM DEMO:
#
# define a class for whatever your data is (e.g. class Play)
# "all" should return all plays and be a class method
# "initialize" creates a new instance of a play
# "create" inserts a play into the database
# "update" updates an instance of a play in the database
#
# define a DBConnection that inherits from SQLite3::Database
# require sqlite3 and Singleton (to ensure you're only working with one copy of the database)
# type_translation ensures returned data is the same datatype as inputed data (i.e., integers stay integers and not string representations of integers)
# results_as_hash returns results as a hash including their column names, rather than an array

class PlayDBConnection < SQLite3::Database

  include Singleton

  def initialize
    super('plays.db') #// uses the initialize method of the parent class
    self.type_translation = true
    self.results_as_hash = true
  end
end


class Play

  attr_accessor :title, :year, :playwright_id

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    # // data is an array of hashes, where each hash is a row in the database
    # // we use instance because we used singleton above -- we're manipulating the one instance
    data.map { |datum| Play.new(datum) }
  end

  def initialize(options)
    # // options is a hash
    # // initialize could be called from the .all class method
    # // or it could be called by a user creating a new play
    # // in the second case, id won't be provided

    @id = options['id'] #// if id isn't defined, this will be nil
    @title = options['title']
    @year = options['year']
    @playwright_id = options[playwright_id]
  end

  def create
    # // create saves instance to the database -- don't save if it already has an id!
    raise "#{self} already in database" if @id
    # // can use HEREDOC for long query -- indicate with << (carats)
    # using the ? (bind arguments) instead of the values prevents SQL INJECTION ATTACKS -- it SANITIZES the database inputs by escaping any characters that could be malicious
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?)
    SQL
    @id = PlayDBConnection.instance.last_insert_row_id
    # since instance now has an id, save it
  end

  def update
    raise "#{self} not in database" unless @id
    PlayDBConnection.instance.execute(<<-SQL, @title, @year, @playwright_id, @id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ?
      WHERE
        id = ?
    SQL
  end

end

# old note -- to run a file in pry, require it
