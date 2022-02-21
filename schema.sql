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

  /* Create a table named vets */
  CREATE TABLE vets(
  id INT GENERATED ALWAYS AS IDENTITY,
  name VARCHAR(255),
  age INT,
  date_of_graduation DATE,
  PRIMARY KEY (id)
);

/* Many-to-Many specializations join table between species and vets */
CREATE TABLE specializations(
  id INT GENERATED ALWAYS AS IDENTITY,
  species_id INT,
  vets_id INT,
  CONSTRAINT key_special_species 
  FOREIGN KEY (species_id)
  REFERENCES species (id),
  CONSTRAINT key_special_vets 
  FOREIGN KEY (vets_id)
  REFERENCES vets (id),
  PRIMARY KEY (id)
);

/* Many-to-Many visits  join table between animals and vets */
CREATE TABLE visits(
  id INT GENERATED ALWAYS AS IDENTITY,
  animal_id INT,
  vets_id INT,
  date_of_visit DATE,
  CONSTRAINT key_visit_animal 
  FOREIGN KEY (animal_id)
  REFERENCES animals (id),
  CONSTRAINT key_visit_vets 
  FOREIGN KEY (vets_id)
  REFERENCES vets (id),
  PRIMARY KEY (id)
);

/* Add email column to owners table */
ALTER TABLE owners ADD COLUMN email VARCHAR(120);

