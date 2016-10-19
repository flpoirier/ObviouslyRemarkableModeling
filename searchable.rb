require_relative 'db_connection'

module Searchable
  def where(params)
    vals = params.values
    attributes = params.keys
    attributes.map! { |attr| "#{attr.to_s} = ?" }
    result = DBConnection.execute2(<<-SQL, *vals)
      SELECT
        *
      FROM
        #{table_name}
      WHERE
        #{attributes.join(" AND ")}
      SQL
    final = []
    result[1..-1].each do |el|
      final << self.new(el)
    end
    final
  end
end