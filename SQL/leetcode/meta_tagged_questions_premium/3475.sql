-- 3475. DNA Pattern Recognition

-- Table: Samples
-- sample_id (int)        -- primary key
-- dna_sequence (varchar)
-- species (varchar)
-- Each row contains a DNA sequence and the species it was collected from.

-- Goal:
-- Identify for each sample whether the DNA sequence has:
-- 1. Starts with ATG (start codon)
-- 2. Ends with TAA, TAG, or TGA (stop codons)
-- 3. Contains the motif ATAT
-- 4. Contains at least 3 consecutive G (GGG or more)
-- Return results ordered by sample_id ascending.

-- MySQL Query

SELECT 
    sample_id,
    dna_sequence,
    species,
    CASE WHEN dna_sequence LIKE 'ATG%' THEN 1 ELSE 0 END AS has_start,
    CASE WHEN dna_sequence LIKE '%TAA' 
          OR dna_sequence LIKE '%TAG' 
          OR dna_sequence LIKE '%TGA' THEN 1 ELSE 0 END AS has_stop,
    CASE WHEN dna_sequence LIKE '%ATAT%' THEN 1 ELSE 0 END AS has_atat,
    CASE WHEN dna_sequence LIKE '%GGG%' THEN 1 ELSE 0 END AS has_ggg
FROM Samples
ORDER BY sample_id ASC;
