/*Queries that provide answers to the questions from all projects.*/

/* Select animals ends with 'mon'*/
SELECT * from animals
WHERE name LIKE '%mon'

/* Select animals born between 2016-2019 */
SELECT * from animals
WHERE date_of_birth 
BETWEEN 'Jan 1, 2016' AND 'Jan 1, 2019';

/* Select animals neutered true and less than 3 escape attempts*/
SELECT * 
  FROM animals 
  WHERE neutered=true 
  AND escape_attempts<3;

/* Select date of birth where animal name is Agumon OR Pikachu*/
SELECT date_of_birth 
  FROM animals 
  Where name = 'Agumon' OR name = 'Pikachu'

/* Select animal name and escape attempts where the weight is greater than 10.5 kg*/
SELECT name,escape_attempts 
FROM animals
where weight_kg > 10.5

/* Select all animal that are neutered = true */
SELECT *
FROM animals
Where neutered= true

/* Select all animals that name is not Gabumon*/
Select *
from animals
where name != 'Gabumon'

/* Select all animals that has weight between 10.4 AND 17.3 */
Select *
from animals
where weight_kg 
between 10.4 AND 17.3

SELECT * FROM animals WHERE name = 'Luna';

/* Count of animals */
SELECT COUNT(*)
  FROM animals;

/* The number of animals that are not attempted to escape */
SELECT COUNT(*)
  FROM animals
  WHERE escape_attempts = 0;

/* Avarage weight of animals */
SELECT AVG(weight_kg)
  FROM animals;

/* Who escaped most by neutered */
SELECT neutered, SUM(escape_attempts)
  FROM animals
  GROUP BY neutered;

/* min max weights of each type of animal*/
SELECT neutered, MIN(weight_kg), MAX(weight_kg)
  FROM animals
  GROUP BY neutered;

/* Average number of escape attempts per animal type of those born between 1990 and 2000 */
SELECT neutered, AVG(escape_attempts)
  FROM animals
  WHERE date_of_birth 
    BETWEEN 'Jan 1, 1990' AND 'Dec 31, 2000'
  GROUP BY neutered;  

/*  Animals belong to Melody Pond */
SELECT animal.name, owner.full_name
  FROM animals animal
  INNER JOIN owners owner
    ON animal.owner_id = owner.id
  WHERE owner.full_name = 'Melody Pond';

/* All animals that are pokemon (their type is Pokemon) */  
SELECT animal.name, spec.name AS type
  FROM animals animal
  INNER JOIN species spec
    ON animal.species_id = spec.id
  WHERE spec.name = 'Pokemon';

/* List of all owners and their animals + owners that don't have animals */
SELECT owner.full_name, animal.name
  FROM owners owner
  FULL OUTER JOIN animals animal
    ON owner.id = animal.owner_id;

/* animals per species */
SELECT spec.name, COUNT(*)
  FROM species spec
  LEFT JOIN animals animal
    ON spec.id =  animal.species_id
  GROUP BY spec.name;

/* All Digimon owned by Jennifer Orwell */
SELECT anim.name, owner.full_name, spec.name
  FROM animals anim
  INNER JOIN owners owner
    ON anim.owner_id = owner.id
  INNER JOIN species spec
    ON anim.species_id = spec.id
  WHERE 
  owner.full_name = 'Jennifer Orwell' 
  AND spec.name = 'Digimon';

/* All animals owned by Dean Winchester that haven't tried to escape */
SELECT anim.name, own.full_name, anim.escape_attempts
  FROM animals anim
  INNER JOIN owners own
    ON anim.owner_id = own.id
  WHERE own.full_name = 'Dean Winchester' 
  AND anim.escape_attempts = 0;

/* Who owns the most animals */
SELECT own.full_name, COUNT(*)
  FROM owners own
  LEFT JOIN animals anim
    ON own.id =  anim.owner_id
  GROUP BY own.full_name
  ORDER BY COUNT DESC
  LIMIT 1;

/* The last animal seen by William Tatcher */
SELECT vt.name AS vet_name, anml.name AS animal_name, vst.date_of_visit
  FROM visits vst
  INNER JOIN animals anml
    ON anml.id = vst.animal_id
  INNER JOIN vets vt
    ON vt.id = vst.vets_id
  WHERE vt.name = 'William Tatcher'
  ORDER BY vst.date_of_visit DESC
  LIMIT 1;

/* Count of  different animals did Stephanie Mendez see */
SELECT vt.name as vet_name, COUNT(date_of_visit) 
  FROM visits vst
  LEFT JOIN vets vt
    ON vst.vets_id = vt.id
  WHERE name = 'Stephanie Mendez'
  GROUP BY vt.name;

/* All vets and their specialties, including vets with no specialties */
SELECT 
  spclty.id AS specialty_id, 
  spclty.species_id, 
  spclty.vets_id, 
  vt.name AS vet_name, 
  spec.name AS species_name  
  FROM specializations spclty
  FULL OUTER JOIN species spec 
    ON spec.id = spclty.species_id
  FULL OUTER JOIN vets vt 
    ON vt.id = spclty.vets_id
;

/* Animals that visited Stephanie Mendez between April 1st and August 30th, 2020 */
SELECT 
  anml.name, 
  vt.name AS vet_name, 
  vst.date_of_visit
  FROM visits vst
  LEFT JOIN animals anml 
    ON anml.id = vst.animal_id
  LEFT JOIN vets vt 
    ON vt.id = vst.vets_id
  WHERE 
    vt.name = 'Stephanie Mendez' AND 
    vst.date_of_visit 
    BETWEEN 'Apr 1, 2020' AND 'Aug 30, 2020';

/* Animal that has the most visits to vets */
SELECT anml.name, COUNT(*) 
  FROM visits vst
  INNER JOIN animals anml
    ON anml.id = vst.animal_id
  GROUP BY anml.name
  ORDER BY COUNT DESC
  LIMIT 1;

/* Maisy Smith's first visit */
SELECT 
  anml.name AS animal_name, 
  vt.name AS vet_name,
  vst.date_of_visit
  FROM visits vst
  LEFT JOIN animals anml
    ON anml.id = vst.animal_id
  LEFT JOIN vets vt
    ON vt.id = vst.vets_id
  WHERE vt.name = 'Maisy Smith'
  ORDER BY vst.date_of_visit ASC
  LIMIT 1;

/* Most recent visit: animal information, vet information, and date of visit */
SELECT * FROM animals anml
    JOIN visits vst
    ON anml.id = vst.animal_id
    JOIN vets vt
    ON vst.vets_id = vt.id
    ORDER BY vst.date_of_visit DESC
    LIMIT 1;
    
/* Visits were with a vet that did not specialize in that animal's species */
SELECT 
  vt.name AS vet_name,
  COUNT(*)
  FROM visits vst
  LEFT JOIN vets vt 
    ON vt.id = vst.vets_id
  LEFT JOIN specializations spcl 
    ON spcl.vets_id = vst.vets_id
  WHERE spcl.id IS NULL
  GROUP BY vt.name;

/* What specialty should Maisy Smith consider getting? Look for the species she gets the most */
SELECT 
  vt.name AS vet_name,
  spec.name AS species_name,
  COUNT(spec.name)
  FROM visits vst
  LEFT JOIN animals anml 
    ON anml.id = vst.animal_id
  LEFT JOIN vets vt 
    ON vt.id = vst.vets_id
  LEFT JOIN species spec
    ON spec.id = anml.species_id
  WHERE vt.name = 'Maisy Smith'
  GROUP BY vt.name, spec.name
  ORDER BY COUNT DESC
  LIMIT 1;