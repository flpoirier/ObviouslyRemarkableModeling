require_relative 'db_connection'
require 'active_support/inflector'

class SQLObject
  def self.columns
    return @columns if @columns

    cols = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    @columns = cols[0].map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col_name|
      define_method(col_name) do
        self.attributes[col_name]
      end

      define_method("#{col_name}=") do |value|
        self.attributes[col_name] = value
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    @table_name || self.to_s.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    results = DBConnection.execute(<<-SQL)
      SELECT
        #{self.table_name}.*
      FROM
        #{self.table_name}
      WHERE
        id = #{id}
    SQL

    return nil if results.empty?
    self.new(results[0])
  end

  def initialize(params = {})
    params.each do |attr_name, value|
      raise "unknown attribute '#{attr_name}'" unless self.class.columns.include?(attr_name.to_sym)
      self.send("#{attr_name}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    vals = []
    self.class.columns.each do |col_name|
      vals << self.send(col_name)
    end
    vals
  end

  def insert
    col_names = self.class.columns.drop(1).map(&:to_s).join(", ")
    question_marks = (["?"] * (attribute_values.length - 1)).join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1))
      INSERT INTO
        #{self.class.table_name} (#{col_names})
      VALUES
        (#{question_marks})
    SQL

    self.id = DBConnection.last_insert_row_id
  end

  def update
    col_names = self.class.columns.drop(1).map {|col| col.to_s + " = ?" }.join(", ")

    DBConnection.execute(<<-SQL, *attribute_values.drop(1), attribute_values[0])
      UPDATE
        #{self.class.table_name}
      SET
        #{col_names}
      WHERE
        id = ?
    SQL
  end

  def save
    id.nil? ? insert : update
  end
end
