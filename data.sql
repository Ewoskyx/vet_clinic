/* Insert initial data. */
INSERT INTO 
  animals 
    (name, date_of_birth, escape_attempts, neutered, weight_kg)
  VALUES
    ('Agumon', 'Feb 3, 2020',0, true, 10.23),
    ('Gabumon', 'Nov 15, 2018',2, true, 8.00),
    ('Pikachu', 'Jan 7, 2021',1, false, 15.04),
    ('Devimon', 'May 12, 2017',5, true, 11.00);

/* Insert new animals */
INSERT INTO
  animals
    (name, date_of_birth, escape_attempts, neutered, weight_kg)
  VALUES
    ('Charmander', 'Feb 8, 2020', 0, false, -11.00),
    ('Plantmon', 'Nov 15, 2022', 2, true, -5.70),
    ('Squirtle', 'Apr 2, 1993', 3, false, -12.13),
    ('Angemon', 'Jun 12, 2005', 1, true, -45.00),
    ('Boarmon', 'Jun 7, 2005', 7, true, 20.40),
    ('Blossom', 'Oct 13, 1998', 3, true, 17.00);

/* Transaction update the animals table by setting the species column to unspecified
*/
BEGIN WORK; 

UPDATE animals
  SET species = 'unspecified';

-- check the changes
SELECT * 
  FROM animals;

--rollback changes 
ROLLBACK WORK;

-- check the changes to verify
SELECT * 
  FROM animals;

/* update the animals table by setting species column to
 digimon if name ends with 'mon', pokemon if species is NULL
*/
BEGIN WORK;

UPDATE animals
  SET species = 'digimon'
  WHERE name LIKE '%mon';

UPDATE animals
  SET species = 'pokemon'
  WHERE species IS NULL;

COMMIT WORK;

SELECT name, species 
  FROM animals;

/* Delete all records in the animals table and Rollback */
BEGIN WORK;

DELETE FROM animals;

ROLLBACK WORK;

/* Multiple transactions on the animals table */
BEGIN WORK;

DELETE FROM animals
  WHERE date_of_birth > 'Jan 1, 2022';

SAVEPOINT my_savepoint;

UPDATE animals 
  SET weight_kg = weight_kg * -1;

ROLLBACK TO SAVEPOINT my_savepoint;

UPDATE animals 
  SET weight_kg = weight_kg * -1
  WHERE weight_kg < 0;

COMMIT WORK;


/* Add Owners Data */
INSERT INTO 
  owners
    (full_name, age)
  VALUES
    ('Sam Smith', 34),
    ('Jennifer Orwell', 19),
    ('Bob', 45),
    ('Melody Pond', 77),
    ('Dean Winchester', 14),
    ('Jodie Whittaker', 38);

/* Add Species Data */
INSERT INTO 
  species
    (name)
  VALUES
    ('Pokemon'),
    ('Digimon');

/* Modify inserted animals so it includes the species_id value 
If the name ends in "mon" it will be Digimon rest should be Pokemon */
BEGIN WORK;

UPDATE animals
  SET species_id = 
        (
          SELECT id 
          FROM species 
          WHERE name = 'Digimon'
        )
  WHERE name LIKE '%mon';

UPDATE animals
  SET species_id = 
        (
          SELECT id 
          FROM species 
          WHERE name = 'Pokemon'
        )
  WHERE species_id IS NULL;

COMMIT WORK;

/* Animals that belongs to owners */
BEGIN WORK;
-- Sam Smith has Agumon
UPDATE animals
  SET owner_id = 
        (
          SELECT id 
          FROM owners 
          WHERE full_name = 'Sam Smith'
        )
  WHERE name = 'Agumon';
-- Jennifer Orwell has Gabumon and Pikachu
UPDATE animals
  SET owner_id = 
        (
          SELECT id 
          FROM owners 
          WHERE full_name = 'Jennifer Orwell'
        )
  WHERE name IN ('Gabumon', 'Pikachu');
-- Bob has Devimon and Plantmon
UPDATE animals
  SET owner_id = 
        (
          SELECT id 
          FROM owners 
          WHERE full_name = 'Bob'
        )
  WHERE name IN ('Devimon','Plantmon');
-- Melody Pond has Charmander', 'Squirtle','Blossom
UPDATE animals
  SET owner_id = 
        (
          SELECT id 
          FROM owners 
          WHERE full_name = 'Melody Pond'
        )
  WHERE name IN ('Charmander', 'Squirtle','Blossom');
-- Dean Winchester  has Angemon and Boarmon
UPDATE animals
  SET owner_id = 
        (
          SELECT id 
          FROM owners 
          WHERE full_name = 'Dean Winchester'
        )
  WHERE name IN ('Angemon', 'Boarmon');

COMMIT WORK;