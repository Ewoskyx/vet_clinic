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

/* Add Column species */
ALTER TABLE animals 
  ADD species VARCHAR(255);


/* Create a table named owners */
CREATE TABLE owners (
    id INT GENERATED ALWAYS AS IDENTITY,
    full_name  VARCHAR(255),
    age INT,
    PRIMARY KEY(id)
);

/* Create a table named species */
CREATE TABLE species (
    id INT GENERATED ALWAYS AS IDENTITY,
    name  VARCHAR(255),
    PRIMARY KEY(id)
);

/* Modify animals table */
-- remove species
ALTER TABLE animals
  DROP species;
-- add species_id relate it with species id as foreign key
ALTER TABLE animals
  ADD species_id INT,
  ADD CONSTRAINT key_species
  FOREIGN KEY (species_id)
  REFERENCES species (id);
-- add owner_id relate it with owners id as foreign key
ALTER TABLE animals
  ADD owner_id INT,
  ADD CONSTRAINT key_owner
  FOREIGN KEY (owner_id)
  REFERENCES owners (id);