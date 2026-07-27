------------------------- Wymiary jakości danych ------------------------------
                            -- Spójność --

/* Cel:
   Ocena spójności danych w kolumnach słownikowych.

   Opis:
   Spójność określa, czy te same informacje są zapisywane
   w jednolity sposób w całym zbiorze danych. */


/* ============================================================================
   Rule ID: DQ-CONS-001
    
   Nazwa: Spójność danych w tabeli kontrahenci, kolumna kraj.

============================================================================ */

SELECT
    kraj,
    COUNT(*) AS liczba_wystąpień
FROM kontrahenci
GROUP BY kraj
ORDER BY liczba_wystąpień DESC;

-- Niepoprawne wartości wraz z liczbą wystąpień
SELECT
    kraj,
    COUNT(*) AS liczba_wystąpień
FROM kontrahenci
WHERE NULLIF(RTRIM(LTRIM(kraj)), '') IS NULL
    OR kraj COLLATE Latin1_General_CS_AS <> 'PL'
GROUP BY kraj
ORDER BY liczba_wystąpień DESC;

-- Procent niespójnych wartości
WITH niespojne_rekordy AS(
    SELECT
    kontrahent_id,
    kraj
FROM kontrahenci
WHERE NULLIF(RTRIM(LTRIM(kraj)), '') IS NULL
    OR kraj COLLATE Latin1_General_CS_AS <> 'PL'
)

SELECT 
    COUNT(*) AS niespójne_wiersze,
    (SELECT COUNT(*) FROM kontrahenci) AS wszystkie_wiersze,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
    ) AS procent_niespójnych_rekordów

FROM niespojne_rekordy;


/* ============================================================================
   Rule ID: DQ-CONS-002
    
   Nazwa: Spójność danych w tabeli kontrahenci, kolumna status.

============================================================================ */

SELECT
    status,
    COUNT(*) AS liczba_wystąpień
from kontrahenci
GROUP BY status
ORDER BY liczba_wystąpień DESC;


/* ============================================================================
   Rule ID: DQ-CONS-003
    
   Nazwa: Spójność danych w tabeli kontrahenci, kolumna typ.

============================================================================ */

SELECT
    typ,
    COUNT(*) AS liczba_wystąpień
from kontrahenci
GROUP BY typ
ORDER BY liczba_wystąpień DESC;


/* ============================================================================
   Rule ID: DQ-CONS-004
    
   Nazwa: Spójność danych w tabeli produkty, kolumna kategoria.

============================================================================ */

SELECT
    kategoria,
    COUNT(*) AS liczba_wystąpień
FROM produkty
GROUP BY kategoria
ORDER BY liczba_wystąpień DESC;


/* ============================================================================
   Rule ID: DQ-CONS-005
    
   Nazwa: Spójność danych w tabeli produkty, kolumna jednostka_miary.

============================================================================ */

SELECT
    jednostka_miary,
    COUNT(*) AS liczba_wystąpień
FROM produkty
GROUP BY jednostka_miary
ORDER BY liczba_wystąpień DESC;

-- Niepoprawne wartości wraz z liczbą wystąpień
SELECT
    jednostka_miary,
    COUNT(*) AS liczba_wystąpień
FROM produkty
WHERE NULLIF(RTRIM(LTRIM(jednostka_miary)), '') IS NULL
    OR jednostka_miary COLLATE Latin1_General_CS_AS <> 'szt'
GROUP BY jednostka_miary
ORDER BY liczba_wystąpień DESC;

-- Procent niespójnych wartości
WITH niespojne_rekordy AS(
    SELECT
    produkt_id,
    jednostka_miary
FROM produkty
WHERE NULLIF(RTRIM(LTRIM(jednostka_miary)), '') IS NULL
    OR jednostka_miary COLLATE Latin1_General_CS_AS <> 'szt'
)

SELECT 
    COUNT(*) AS niespójne_wiersze,
    (SELECT COUNT(*) FROM produkty) AS wszystkie_wiersze,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
    ) AS procent_niespójnych_rekordów

FROM niespojne_rekordy;


/* ============================================================================
   Rule ID: DQ-CONS-006
    
   Nazwa: Spójność danych w tabeli produkty, kolumna stawka_vat.

============================================================================ */

SELECT
    stawka_vat,
    COUNT(*) AS liczba_wystąpień
FROM produkty
GROUP BY stawka_vat
ORDER BY liczba_wystąpień DESC;

-- Niepoprawne wartości wraz z liczbą wystąpień
SELECT
    stawka_vat,
    COUNT(*) AS liczba_wystąpień
FROM produkty
WHERE stawka_vat <> '23'
    AND NULLIF(RTRIM(LTRIM(stawka_vat)), '') IS NOT NULL
GROUP BY stawka_vat
ORDER BY liczba_wystąpień DESC;

-- Procent niespójnych wartości
WITH niespojne_rekordy AS(
    SELECT
        produkt_id,
        stawka_vat
    FROM produkty
    WHERE stawka_vat <> '23'
        AND NULLIF(RTRIM(LTRIM(stawka_vat)), '') IS NOT NULL
)

SELECT 
    COUNT(*) AS niespójne_wiersze,
    (SELECT COUNT(*) FROM produkty) AS wszystkie_wiersze,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
    ) AS procent_niespójnych_rekordów

FROM niespojne_rekordy;


/* ============================================================================
   Rule ID: DQ-CONS-007
    
   Nazwa: Spójność danych w tabeli umowy, kolumna waluta.

============================================================================ */

SELECT
    waluta,
    COUNT(*) AS liczba_wystąpień
FROM umowy
GROUP BY waluta
ORDER BY liczba_wystąpień DESC;

-- Niepoprawne wartości wraz z liczbą wystąpień
SELECT
    waluta,
    COUNT(*) AS liczba_wystąpień
FROM umowy
WHERE NULLIF(RTRIM(LTRIM(waluta)), '') IS NOT NULL
    AND (waluta COLLATE Latin1_General_CS_AS <> 'PLN'
        OR waluta LIKE '% ' OR waluta LIKE ' %' )

GROUP BY waluta
ORDER BY liczba_wystąpień DESC;

-- Procent niespójnych wartości
WITH niespojne_rekordy AS(     
    SELECT
        umowa_id,
        waluta
    FROM umowy
    WHERE NULLIF(RTRIM(LTRIM(waluta)), '') IS NOT NULL
        AND (waluta COLLATE Latin1_General_CS_AS <> 'PLN'
            OR waluta LIKE '% ' OR waluta LIKE ' %' )
)

SELECT
    COUNT(*) AS niespójne_wiersze,
    (SELECT COUNT(*) FROM umowy) AS wszystkie_wiersze,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
    ) AS procent_niespójnych_rekordów

FROM niespojne_rekordy;
