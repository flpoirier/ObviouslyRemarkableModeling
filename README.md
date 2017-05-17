Obviously Remarkable Modeling is a Ruby ORM built to mimic ActiveRecord.

How to use:

1. Create your SQL file. (See books.sql for an example.)
2. Convert it to a .db file by running "cat import <file_name>.sql | sqlite3 <file_name>.db" in the console.
3. Create models corresponding to your SQL tables. Models should inherit from SQLObject and require modules/associatable. (See model.rb for an example.)


Functionality:
