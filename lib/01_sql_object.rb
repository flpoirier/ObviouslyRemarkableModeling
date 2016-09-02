require_relative 'db_connection'
require 'active_support/inflector'

# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject

  #this extracts the columns directly from the DB, so id is included.
  def self.columns
    @columns ||= DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      SQL
    @columns[0].map { |col| col.to_sym }
  end

  def self.finalize!
    self.columns.each do |name|
      define_method(name) do
        self.attributes[name]
      end

      define_method("#{name}=") do |value|
        self.attributes[name] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name ||= self.to_s.tableize
  end

  #returns an array. first element is an array of columns names. rest of the
  #elements are hashes -- one per object (keys are column names, vals are attributes.)
  def self.all
    result = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      SQL
      self.parse_all(result[1..-1])
  end

  def self.parse_all(results)
    final = []
    results.each do |params|
      final << self.new(params)
    end
    final
  end

  #here we are pulling something from the DB, so it does come w an id.
  def self.find(id)
    result = DBConnection.execute2(<<-SQL, id)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        id = ?
      SQL
    return nil if result.length == 1
    self.new(result[1])
  end

  def initialize(params = {})
    params.each do |attr_name, val|
      attr_name = attr_name.to_sym
      if self.class.columns.include?(attr_name)
        self.send("#{attr_name}=", val)
      else
        raise "unknown attribute '#{attr_name}'"
      end
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    @attributes.values
  end

  #we always want this to be the same length as attr_val, bc that's what it's subbing for.
  def question_marks
    result = ["?"] * (self.attribute_values.length)
    @question_marks = result.join(", ")
  end

  #columns comes from the DB, so we have to drop one to not get the id column!
  def col_names
    cols = self.class.columns.drop(1)
    cols = cols.map {|el| el.to_s }
    @col_names = cols.join(", ")
  end

  #okay, when we're inserting, we've just made a new human, not
  #extracted one from the DB, so we don't have to worry about dropping the ID --
  #humans don't get initialized with a DB, they only get them upon DB insertion.

  def insert
    DBConnection.execute(<<-SQL, *attribute_values)
      INSERT INTO
        #{self.class.table_name} (#{self.col_names})
      VALUES
        (#{self.question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  #whereas HERE, we're updating something that's in the DB already -- so its
  #attributes will include ID, and therefore we have to drop the first element.
  def update

    cols = self.class.columns.drop(1)
    attr_with_ques_marks = cols.map {|el| el.to_s + " = ?"}

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      UPDATE
        #{self.class.table_name}
      SET
        #{attr_with_ques_marks.join(", ")}
      WHERE
        id = #{self.id}
    SQL
  end


  def save
    if id.nil?
      insert
    else
      update
    end
  end

end
