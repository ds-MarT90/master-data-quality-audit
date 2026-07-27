------------------------- Wymiary jakości danych ------------------------------
                            -- Aktualność --

/* Cel:
   Ocena aktualności danych oraz poprawności zależności czasowych.

   Opis:
   Aktualność danych określa, czy informacje są zapisane
   zgodnie z oczekiwaną chronologią oraz odnoszą się
   do właściwego momentu w czasie. */


/* ============================================================================
   Rule ID: DQ-TIME-001
    
   Nazwa: Poprawność zależności czasowych danych w tabeli kontrahenci, 
   założenie: data_utworzenia <= bieżąca data.

============================================================================ */

SELECT
    kontrahent_id,
    data_utworzenia
FROM kontrahenci
WHERE TRY_CAST(data_utworzenia AS date) > CAST(GETDATE() AS date);

-- Ilość niepoprawnych zależności czasowych, procentowy udział
WITH niepoprawne_daty  AS (
    SELECT
        kontrahent_id,
        data_utworzenia
    FROM kontrahenci
    WHERE TRY_CAST(data_utworzenia AS date) > CAST(GETDATE() AS date)
)

SELECT
    COUNT(*) AS ilość_nieprawidłowości,
    (SELECT COUNT(*) FROM kontrahenci) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
    ) AS procent_niepoprawności_czasowych

FROM niepoprawne_daty ;


/* ============================================================================
   Rule ID: DQ-TIME-002
    
   Nazwa: Poprawność zależności czasowych danych w tabeli produkty, 
   założenie: data_utworzenia <= bieżąca data.

============================================================================ */

SELECT
    produkt_id,
    data_utworzenia
FROM produkty
WHERE TRY_CAST(data_utworzenia AS date) > CAST(GETDATE() AS date);

-- Ilość niepoprawnych zależności czasowych, procentowy udział
WITH niepoprawne_daty  AS (
    SELECT
        produkt_id,
        data_utworzenia
    FROM produkty
    WHERE TRY_CAST(data_utworzenia AS date) > CAST(GETDATE() AS date)
)

SELECT
    COUNT(*) AS ilość_nieprawidłowości,
    (SELECT COUNT(*) FROM produkty) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
    ) AS procent_niepoprawności_czasowych

FROM niepoprawne_daty ;


/* ============================================================================
   Rule ID: DQ-TIME-003
    
   Nazwa: Poprawność zależności czasowych danych w tabeli umowy, 
   założenie: data_podpisania <= data_rozpoczecia.

============================================================================ */

SELECT
    umowa_id,
    data_podpisania,
    data_rozpoczecia
FROM umowy
WHERE data_podpisania > data_rozpoczecia;

-- Ilość niepoprawnych zależności czasowych, procentowy udział
WITH niepoprawne_daty  AS (
    SELECT
        umowa_id,
        data_podpisania,
        data_rozpoczecia
    FROM umowy
    WHERE data_podpisania > data_rozpoczecia
)

SELECT
    COUNT(*) AS ilość_nieprawidłowości,
    (SELECT COUNT(*) FROM umowy) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
    ) AS procent_niepoprawności_czasowych

FROM niepoprawne_daty ;


/* ============================================================================
   Rule ID: DQ-TIME-004
    
   Nazwa: Poprawność zależności czasowych danych w tabeli umowy, 
   założenie: data_rozpoczecia <= data_zakonczenia.

============================================================================ */

SELECT
    umowa_id,
    data_rozpoczecia,
    data_zakonczenia
FROM umowy
WHERE data_rozpoczecia > data_zakonczenia;

-- Ilość niepoprawnych zależności czasowych, procentowy udział
WITH niepoprawne_daty  AS (
    SELECT
        umowa_id,
        data_rozpoczecia,
        data_zakonczenia
    FROM umowy
    WHERE data_rozpoczecia > data_zakonczenia
)

SELECT
    COUNT(*) AS ilość_nieprawidłowości,
    (SELECT COUNT(*) FROM umowy) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
    ) AS procent_niepoprawności_czasowych

FROM niepoprawne_daty ;


/* ============================================================================
   Rule ID: DQ-TIME-005
    
   Nazwa: Poprawność zależności czasowych danych w tabeli umowy, 
   założenie: data_podpisania <= bieżąca data.

============================================================================ */

SELECT
    umowa_id,
    data_podpisania
FROM umowy
WHERE data_podpisania > CAST(GETDATE() AS date);

-- Ilość niepoprawnych zależności czasowych, procentowy udział
WITH niepoprawne_daty  AS (
    SELECT
        umowa_id,
        data_podpisania
    FROM umowy
    WHERE data_podpisania > CAST(GETDATE() AS date)
)

SELECT
    COUNT(*) AS ilość_nieprawidłowości,
    (SELECT COUNT(*) FROM umowy) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
    ) AS procent_niepoprawności_czasowych
FROM niepoprawne_daty ;




