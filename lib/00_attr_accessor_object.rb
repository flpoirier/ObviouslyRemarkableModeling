
class AttrAccessorObject

  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method("#{name}=") do |value|
        instance_variable_set("@#{name}", value)
      end

      define_method(name) do
        instance_variable_get("@#{name}")
      end
    end
  end

end


# names.each do |arg|
#   #Here's the getter
#   self.class_eval("def #{arg};@#{arg};end")
#   #Here's the setter
#   self.class_eval("def #{arg}=(val);@#{arg}=val;end")
# end

# names.each do |name|
#   define_method(name) { puts "#{name}" }
# end

# names.each do |method|
#   define_method(method) do |arg = nil|
#     if arg.nil?
#       self.method = "#{method}"
#     else
#       self.method = arg
#     end
#   end
# end


# testing

# class String
#
#   define_method("apple") do |args = nil|
#     if args.nil?
#       puts "apple"
#     else
#       puts args
#     end
#   end
#
# end
#
# class String
#
#   def self.method_factory(*names)
#     names.each do |name|
#       define_method(name) { puts "#{name}" }
#     end
#   end
#
# end
