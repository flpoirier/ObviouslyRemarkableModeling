require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(:foreign_key, :class_name, :primary_key)

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})

    default = {
      primary_key: :id,
      class_name: name.camelcase,
      foreign_key: (name.to_s + "_id").to_sym
    }

    options = default.merge(options)

    options.each do |attr_name, val|
      self.send("#{attr_name}=", val)
    end

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})

    default = {
      primary_key: :id,
      class_name: name.classify,
      foreign_key: (self_class_name.downcase + "_id").to_sym
    }

    options = default.merge(options)

    options.each do |attr_name, val|
      self.send("#{attr_name}=", val)
    end

  end
end
