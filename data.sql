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

/* Data for vets */
INSERT INTO
  vets
    (name, age, date_of_graduation)
  VALUES
    ('William Tatcher', 45, 'Apr 23, 2000'),
    ('Maisy Smith', 26, 'Jan 17, 2019'),
    ('Stephanie Mendez', 64, 'May 4, 1981'),
    ('Jack Harkness', 38, 'Jun 8, 2008');

/* Data for specialities */
INSERT INTO 
  specializations
    (species_id, vets_id)
  VALUES
    (
      (
        SELECT id 
        FROM species 
        WHERE name = 'Pokemon'
      ),
      (
        SELECT id 
        FROM vets 
        WHERE name = 'William Tatcher'
      )
    ),
    (
      (
        SELECT id 
        FROM species 
        WHERE name = 'Pokemon'
      ),
      (
        SELECT id 
        FROM vets 
        WHERE name = 'Stephanie Mendez'
      )
    ),
    (
      (
        SELECT id 
        FROM species 
        WHERE name = 'Digimon'
      ),
      (
        SELECT id 
        FROM vets 
        WHERE name = 'Stephanie Mendez'
      )
    ),
    (
      (
        SELECT id 
        FROM species 
        WHERE name = 'Digimon'
      ),
      (
        SELECT id 
        FROM vets 
        WHERE name = 'Jack Harkness'
      )
    );

/* Data for visits */
INSERT INTO
  visits
    (animal_id, vets_id,  date_of_visit)
  VALUES 
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Agumon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'William Tatcher'
      ),
      'May 24, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Agumon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Stephanie Mendez'
      ),
      'Jul 22, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Gabumon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Jack Harkness'
      ),
      'Feb 2, 2021'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Pikachu'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'Jan 5, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Pikachu'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'Mar 8, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Pikachu'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'May 14, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Devimon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Stephanie Mendez'
      ),
      'May 4, 2021'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Charmander'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Jack Harkness'
      ),
      'Feb 24, 2021'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Plantmon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'Dec 21, 2019'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Plantmon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'William Tatcher'
      ),
      'Aug 10, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Plantmon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'Apr 7, 2021'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Squirtle'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Stephanie Mendez'
      ),
      'Sep 29, 2019'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Angemon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Jack Harkness'
      ),
      'Oct 3, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Angemon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Jack Harkness'
      ),
      'Nov 4, 2020'
    ),
    (
      (
        SELECT id
        FROM animals
        WHERE name = 'Boarmon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'Jan 24, 2019'
    ),
     (
      (
        SELECT id
        FROM animals
        WHERE name = 'Boarmon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'May 15, 2019'
    ),
     (
      (
        SELECT id
        FROM animals
        WHERE name = 'Boarmon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'Feb 27, 2020'
    ),
     (
      (
        SELECT id
        FROM animals
        WHERE name = 'Boarmon'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Maisy Smith'
      ),
      'Aug 3, 2020'
    ),
     (
      (
        SELECT id
        FROM animals
        WHERE name = 'Blossom'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'Stephanie Mendez'
      ),
      'May 24, 2020'
    ),
     (
      (
        SELECT id
        FROM animals
        WHERE name = 'Blossom'
      ),
      (
        SELECT id 
        FROM vets
        WHERE name = 'William Tatcher'
      ),
      'Jan 11, 2021'
    );
/* Add visits Data */
INSERT INTO visits (animal_id, vet_id, date_of_visit) SELECT * FROM (SELECT id FROM animals) animal_ids, (SELECT id FROM vets) vets_ids, generate_series('1980-01-01'::timestamp, '2021-01-01', '4 hours') visit_timestamp;

/* Add Owners Data */
insert into owners (full_name, email) select 'Owner ' || generate_series(1,2500000), 'owner_' || generate_series(1,2500000) || '@mail.com';

/* Remove Duplicated Data for 3NF */
DELETE FROM
    visits a
        USING visits b
WHERE
    a.id < b.id
    AND a.animal_id = b.animal_id AND a.date_of_visit = b.date_of_visit AND a.vets_id = b.vets_id