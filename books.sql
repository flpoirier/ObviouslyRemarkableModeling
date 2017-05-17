CREATE TABLE books (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  author_id INTEGER NOT NULL,
  genre_id INTEGER,

  FOREIGN KEY(author_id) REFERENCES author(id),
  FOREIGN KEY(genre_id) REFERENCES genre(id)
);

CREATE TABLE authors (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE genres (
  id INTEGER PRIMARY KEY,
  genre VARCHAR(255) NOT NULL
);




INSERT INTO
  genres (genre)
VALUES
  ("fantasy"), ("science fiction"), ("biography");

INSERT INTO
  authors (fname, lname)
VALUES
  ("Isaac", "Asimov"),
  ("Ursula", "Le Guin"),
  ("J.K.", "Rowling"),
  ("Ron", "Chernow");

INSERT INTO
  books (title, author_id, genre_id)
VALUES
  ("Foundation", 1, 2),
  ("The Dispossessed", 2, 2),
  ("Harry Potter and the Chamber of Secrets", 3, 1),
  ("Harry Potter and the Prisoner of Azkaban", 3, 1),
  ("The Left Hand of Darkness", 2, 2),
  ("Alexander Hamilton", 4, 3);
