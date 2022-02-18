/* Create a table named animals */
CREATE TABLE animals(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255) NOT NULL,
  date_of_birth DATE,
  escape_attempts INT,
  neutered BOOLEAN,
  weight_kg DECIMAL,
  PRIMARY KEY(id)
);
/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    name varchar(100)
);
