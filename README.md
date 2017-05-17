Obviously Remarkable Modeling is a Ruby ORM built to mimic ActiveRecord.

How to use:

1. Create your SQL file. (See books.sql for an example.)
2. Convert it to a .db file by running "cat import <file_name>.sql | sqlite3 <file_name>.db" in the console.
3. Create models corresponding to your SQL tables. Models should inherit from SQLObject and require modules/associatable. (See model.rb for an example.) Make sure to add 'finalize!' to each model.


Functionality:

If you'd like to test this out, you can require 'pry' in your model file and add 'binding.pry' to the end of the file. Run 'ruby model.rb' in the console to try out some of the commands. Feel free to use the provided sample model.rb file.

Most ActiveRecord commands will work, including .all, .where, .find, .new, and .save. Associations are also functional.
