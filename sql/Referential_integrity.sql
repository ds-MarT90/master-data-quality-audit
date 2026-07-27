------------------------- Wymiary jakości danych ------------------------------
                     -- Integralność referencyjna --

/* Cel:
   Ocena integralności referencyjnej pomiędzy powiązanymi tabelami.

   Opis:
   Integralność referencyjna określa, czy wszystkie relacje
   pomiędzy tabelami odwołują się do istniejących rekordów.
   Naruszenie integralności referencyjnej prowadzi do powstawania
   rekordów osieroconych, które mogą powodować błędy analiz,
   raportowania oraz procesów biznesowych. */

/* ============================================================================
   Rule ID: DQ-REF-001
    
   Nazwa: Sprawdzenie rekordów osieroconych w tabeli umowy.

============================================================================ */

SELECT 
    u.umowa_id,
    u.kontrahent_id AS kontrahent_id_umowy
FROM umowy AS u
LEFT JOIN kontrahenci AS k
    ON u.kontrahent_id = k.kontrahent_id
WHERE k.kontrahent_id IS NULL 
    AND u.kontrahent_id IS NOT NULL;

-- Ilość i procent umów przypisanych do nieistniejącego kontrahenta
WITH umowy_bez_kontrahenta AS(
    SELECT 
        u.umowa_id,
        u.kontrahent_id AS kontrahent_id_umowy
    FROM umowy AS u
    LEFT JOIN kontrahenci AS k
        ON u.kontrahent_id = k.kontrahent_id
    WHERE k.kontrahent_id IS NULL 
        AND u.kontrahent_id IS NOT NULL
)

SELECT 
    COUNT(*) AS rekordy_osierocone,
    (SELECT COUNT(*) FROM umowy) AS wszystkie_umowy,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) from umowy) AS DECIMAL(5,2)
    ) AS procent_błędów

FROM umowy_bez_kontrahenta;


/* ============================================================================
   Rule ID: DQ-REF-002
    
   Nazwa: Sprawdzenie rekordów osieroconych w tabeli crm_kontakty.

============================================================================ */

SELECT
    c.kontakt_id,
    c.kontrahent_id
FROM crm_kontakty AS c
LEFT JOIN kontrahenci as k
    ON c.kontrahent_id = k.kontrahent_id
WHERE k.kontrahent_id IS NULL
    AND c.kontrahent_id IS NOT NULL;

-- Ilość i procent kontaktów przypisanych do nieistniejącego kontrahenta
WITH kontakty_bez_kontrahenta AS(
    SELECT
        c.kontakt_id,
        c.kontrahent_id
    FROM crm_kontakty AS c
    LEFT JOIN kontrahenci as k
        ON c.kontrahent_id = k.kontrahent_id
    WHERE k.kontrahent_id IS NULL
        AND c.kontrahent_id IS NOT NULL
)

SELECT 
    COUNT(*) AS rekordy_osierocone,
    (SELECT COUNT(*) FROM crm_kontakty) AS wszystkie_kontakty,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) from crm_kontakty) AS DECIMAL(5,2)
    ) AS procent_błędów

FROM kontakty_bez_kontrahenta;


/* ============================================================================
   Rule ID: DQ-REF-003
    
   Nazwa: Sprawdzenie rekordów osieroconych w tabeli srodki_trwale.

============================================================================ */

SELECT
    s.srodek_id,
    s.dostawca_id
FROM srodki_trwale AS s
LEFT JOIN kontrahenci as k
    ON s.dostawca_id = k.kontrahent_id
WHERE k.kontrahent_id IS NULL
    AND s.dostawca_id IS NOT NULL;

-- Ilość i procent kontaktów przypisanych do nieistniejącego kontrahenta
WITH srodki_bez_kontrahenta AS(
    SELECT
        s.srodek_id,
        s.dostawca_id
    FROM srodki_trwale AS s
    LEFT JOIN kontrahenci as k
        ON s.dostawca_id = k.kontrahent_id
    WHERE k.kontrahent_id IS NULL
        AND s.dostawca_id IS NOT NULL
)

SELECT 
    COUNT(*) AS rekordy_osierocone,
    (SELECT COUNT(*) FROM crm_kontakty) AS wszystkie_kontakty,
    CAST(
        100.0 * COUNT(*)
        / (SELECT COUNT(*) from crm_kontakty) AS DECIMAL(5,2)
    ) AS procent_błędów

FROM srodki_bez_kontrahenta;