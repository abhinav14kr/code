-- 175. Combine Two Tables

-- Table: Person
-- personId is the primary key.
-- Contains ID, first name, and last name.

-- Table: Address
-- addressId is the primary key.
-- Contains city and state for each personId.

-- Task:
-- Report firstName, lastName, city, and state for every person.
-- If a person has no address, return NULL for city/state.

-- MySQL Query
SELECT 
    p.firstName,
    p.lastName,
    COALESCE(a.city, NULL) AS city,
    COALESCE(a.state, NULL) AS state
FROM Person p
LEFT JOIN Address a 
    ON a.personId = p.personId;
