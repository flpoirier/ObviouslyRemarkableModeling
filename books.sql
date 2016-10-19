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
  genres (id, genre)
VALUES
  (1, "fantasy"), (2, "science fiction"), (3, "biography");

INSERT INTO
  authors (id, fname, lname)
VALUES
  (1, "Isaac", "Asimov"),
  (2, "Ursula", "Le Guin"),
  (3, "J.K.", "Rowling"),
  (4, "Ron", "Chernow");

INSERT INTO
  books (id, title, author_id, genre_id)
VALUES
  (1, "Foundation", 1, 2),
  (2, "The Dispossessed", 2, 2),
  (3, "Harry Potter and the Chamber of Secrets", 3, 1),
  (4, "Harry Potter and the Prisoner of Azkaban", 3, 1),
  (5, "The Left Hand of Darkness", 2, 2),
  (6, "Alexander Hamilton", 4, 3);
