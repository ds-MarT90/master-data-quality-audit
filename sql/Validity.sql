------------------------- Wymiary jakości danych ------------------------------
                            -- Poprawność --

/* Cel:
   Ocena poprawności danych w kluczowych tabelach systemu.

   Opis:
   Poprawność określa, czy wartości są zgodne z wymaganym formatem,
   zakresem oraz zdefiniowanymi regułami biznesowymi. Niepoprawne dane
   mogą prowadzić do błędów w procesach biznesowych, analizach oraz
   raportowaniu. */


/* ============================================================================
   Rule ID: DQ-VALID-001
    
   Nazwa: Poprawność danych w tabeli kontrahenci, kolumna nip.

============================================================================ */

SELECT
    kontrahent_id,
    nip
FROM kontrahenci
WHERE NULLIF(RTRIM(LTRIM(nip)), '') IS NOT NULL
    AND (LEN(nip) <> 10 OR nip LIKE '%[^0-9]%');


WITH błędny_nip AS(

    SELECT
    kontrahent_id,
    nip
FROM kontrahenci
WHERE NULLIF(RTRIM(LTRIM(nip)), '') IS NOT NULL
    AND (LEN(nip) <> 10 OR nip LIKE '%[^0-9]%')
)

SELECT 
    COUNT(*) AS ilość_błędnych,
    (SELECT COUNT(*) FROM kontrahenci) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*)FROM kontrahenci) AS DECIMAL (5,2)
    ) AS procent_nieprawidłowych_nip

FROM błędny_nip;

/* ============================================================================
   Rule ID: DQ-VALID-002
    
   Nazwa: Poprawność danych w tabeli kontrahenci, kolumna regon.

============================================================================ */

SELECT
    kontrahent_id,
    regon
FROM kontrahenci
WHERE NULLIF(RTRIM(LTRIM(CAST(regon AS varchar(14)))), '') IS NOT NULL
AND LEN(CAST(regon AS varchar(14))) NOT IN (9, 14);

WITH błędny_regon AS(

    SELECT
        kontrahent_id,
        regon
    FROM kontrahenci
    WHERE LEN(CAST(regon AS varchar(14))) NOT IN (9, 14)
)

SELECT 
    COUNT(*) AS ilość_błędnych,
    (SELECT COUNT(*) FROM kontrahenci) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*)FROM kontrahenci) AS DECIMAL (5,2)
    ) AS procent_nieprawidłowych_regon

FROM błędny_regon;


/* ============================================================================
   Rule ID: DQ-VALID-003
    
   Nazwa: Poprawność danych w tabeli kontrahenci, kolumna kod_pocztowy.

============================================================================ */

SELECT
    kontrahent_id,
    kod_pocztowy
FROM kontrahenci
WHERE NULLIF(RTRIM(LTRIM(kod_pocztowy)), '') IS NOT NULL
    AND kod_pocztowy NOT LIKE '[0-9][0-9]-[0-9][0-9][0-9]';

WITH błędny_kod_pocztowy AS(

    SELECT
        kontrahent_id,
        kod_pocztowy
    FROM kontrahenci
    WHERE NULLIF(RTRIM(LTRIM(kod_pocztowy)), '') IS NOT NULL
        AND kod_pocztowy NOT LIKE '[0-9][0-9]-[0-9][0-9][0-9]'
)

SELECT 
    COUNT(*) AS ilość_błędnych,
    (SELECT COUNT(*) FROM kontrahenci) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*)FROM kontrahenci) AS DECIMAL (5,2)
    ) AS procent_nieprawidłowych_kodów

FROM błędny_kod_pocztowy;


/* ============================================================================
   Rule ID: DQ-VALID-004
    
   Nazwa: Poprawność danych w tabeli kontrahenci, kolumna email.

============================================================================ */

SELECT
    kontrahent_id,
    email
FROM kontrahenci
WHERE NULLIF(LTRIM(RTRIM(email)), '') IS NOT NULL
    AND email NOT LIKE '%_@_%._%';


WITH błędne_email AS(
    SELECT
        kontrahent_id,
        email
    FROM kontrahenci
    WHERE NULLIF(LTRIM(RTRIM(email)), '') IS NOT NULL
        AND email NOT LIKE '%_@_%._%'
)

SELECT 
    COUNT(*) AS ilość_błędnych,
    (SELECT COUNT(*) FROM kontrahenci) AS wszystkie_rekordy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
    ) AS procent_nieprawidłowych_email

FROM błędne_email;


/* ============================================================================
   Rule ID: DQ-VALID-005
    
   Nazwa: Poprawność danych w tabeli kontrahenci, kolumna telefon.

============================================================================ */

SELECT
    kontrahent_id,
    telefon
FROM kontrahenci
WHERE NULLIF(RTRIM(LTRIM(telefon)), '') IS NOT NULL
    AND (LEN(telefon) <> 16);

    -- |+NN NN NNN NN NN| - 16 znaków, po sformatowaniu w inny sposób potrzeba
    -- zaktualizować warunek.

/* ============================================================================
   Rule ID: DQ-VALID-006
    
   Nazwa: Poprawność danych w tabeli kontrahenci, kolumna typ.

============================================================================ */

SELECT 
    DISTINCT typ
FROM kontrahenci;

SELECT
    kontrahent_id,
    typ
FROM kontrahenci
WHERE typ NOT IN ('klient', 'dostawca', 'oba');

/* ============================================================================
   Rule ID: DQ-VALID-007
    
   Nazwa: Poprawność danych w tabeli kontrahenci, kolumna status.

============================================================================ */

SELECT 
    DISTINCT status
FROM kontrahenci;

SELECT
    kontrahent_id,
    status
FROM kontrahenci
WHERE status NOT IN ('aktywny', 'nieaktywny');


/* ============================================================================
   Rule ID: DQ-VALID-008
    
   Nazwa: Poprawność danych w tabeli produkty, kolumna kategoria.

============================================================================ */

SELECT
    DISTINCT kategoria
FROM produkty;

SELECT
    produkt_id,
    kategoria
FROM produkty
WHERE NULLIF(RTRIM(LTRIM(kategoria)), '') IS NOT NULL
    AND kategoria NOT IN (
        'Materiały zużywalne', 'Aparatura', 
        'Szkło laboratoryjne', 'Sprzęt laboratoryjny', 
        'Podłoża mikrobiologiczne', 'Odczynniki'
        );


/* ============================================================================
   Rule ID: DQ-VALID-009
    
   Nazwa: Poprawność danych w tabeli produkty, kolumna cena_zakupu.

============================================================================ */

SELECT
    produkt_id,
    cena_zakupu
FROM produkty
WHERE cena_zakupu < 0;

WITH ujemne_ceny AS(
    SELECT
        produkt_id,
        cena_zakupu
    FROM produkty
    WHERE cena_zakupu < 0
)

SELECT COUNT(*) AS ilość_błędów,
(SELECT COUNT(*) FROM produkty) AS wszystkie_rekordy,
CAST(
    100.0 * COUNT(*)
    / (SELECT COUNT(*) FROM produkty) AS DECIMAL (5,2)
) AS procent_nieprawidłowych_cen

FROM ujemne_ceny;


/* ============================================================================
   Rule ID: DQ-VALID-010
    
   Nazwa: Poprawność danych w tabeli produkty, kolumna cena_sprzedaży.

============================================================================ */

SELECT
    produkt_id,
    cena_sprzedazy
FROM produkty
WHERE cena_sprzedazy < 0;

WITH ujemne_ceny AS(
    SELECT
        produkt_id,
        cena_sprzedazy
    FROM produkty
    WHERE cena_sprzedazy < 0
)

SELECT COUNT(*) AS ilość_błędów,
(SELECT COUNT(*) FROM produkty) AS wszystkie_rekordy,
CAST(
    100.0 * COUNT(*)
    / (SELECT COUNT(*) FROM produkty) AS DECIMAL (5,2)
) AS procent_nieprawidłowych_cen

FROM ujemne_ceny;


/* ============================================================================
   Rule ID: DQ-VALID-011
    
   Nazwa: Poprawność danych w tabeli produkty, kolumna ean.

============================================================================ */

SELECT
    produkt_id,
    ean
FROM produkty
WHERE NULLIF(LTRIM(RTRIM(ean)), '') IS NOT NULL
    AND LEN(ean) <> 13 
    OR ean LIKE '%[^0-9]%';

WITH nieprawidłowy_ean AS(
    SELECT
        produkt_id,
        ean
    FROM produkty
    WHERE NULLIF(LTRIM(RTRIM(ean)), '') IS NOT NULL
        AND LEN(ean) <> 13 
        OR ean LIKE '%[^0-9]%'
)

SELECT COUNT(*) AS ilość_błędów,
(SELECT COUNT(*) FROM produkty) AS wszystkie_rekordy,
CAST(
    100.0 * COUNT(*)
    / (SELECT COUNT(*) FROM produkty) AS DECIMAL (5,2)
) AS procent_nieprawidłowych_ean

FROM nieprawidłowy_ean;


/* ============================================================================
   Rule ID: DQ-VALID-012
    
   Nazwa: Poprawność danych w tabeli produkty, kolumna status.

============================================================================ */

SELECT
    DISTINCT status
FROM produkty;

SELECT
    produkt_id,
    status
FROM produkty
WHERE NULLIF(LTRIM(RTRIM(status)), '') IS NOT NULL
    AND status NOT IN ('aktywny', 'nieaktywny');


/* ============================================================================
   Rule ID: DQ-VALID-013
    
   Nazwa: Cena sprzedaży nie może być niższa lub równa cenie zakupu.

============================================================================ */

SELECT
    produkt_id,
    (cena_sprzedazy - cena_zakupu) AS marża
FROM produkty
WHERE cena_zakupu >= cena_sprzedazy;


-- Ilość i procent nieporprawnych rekordów
WITH produkty_z_ujemną_marżą AS(
    SELECT
        produkt_id,
        (cena_sprzedazy - cena_zakupu) AS marża
    FROM produkty
    WHERE cena_zakupu >= cena_sprzedazy
)

SELECT 
    COUNT(*) AS ilość_błędnych_wierszy,
    (SELECT COUNT(*) FROM produkty) AS wszystkie_wiersze,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
    ) AS procent_błędnych_wierszy

FROM produkty_z_ujemną_marżą;