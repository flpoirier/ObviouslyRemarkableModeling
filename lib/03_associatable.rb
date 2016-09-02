require_relative '02_searchable'
require 'active_support/inflector'

# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})

    default = {primary_key: :id,
               class_name: name.camelcase,
               foreign_key: (name.to_s + "_id").to_sym}

    options = default.merge(options)

    options.each do |attr_name, val|
      self.send("#{attr_name}=", val)
    end

  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})

    default = {primary_key: :id,
               class_name: name.classify,
               foreign_key: (self_class_name.downcase + "_id").to_sym}
    options = default.merge(options)

    options.each do |attr_name, val|
      self.send("#{attr_name}=", val)
    end

  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    # self.assoc_options[name] = BelongsToOptions.new(name, options)

    define_method(name) do
      options = self.class.options[name]

      key_val = self.send(options.foreign_key)
      options
        .model_class
        .where(options.primary_key => key_val)
        .first
    end

  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase IVa. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
  # Mixin Associatable here...
end
