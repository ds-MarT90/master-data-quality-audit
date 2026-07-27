---------------------------------- Dashboard --------------------------------------
TRUNCATE TABLE dq_wyniki;


-- DQ-COMP-001 | kontrahenci | brak NIP |
WITH DQ_COMP_001 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(100.0 * COUNT(*) / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE NULLIF(LTRIM(RTRIM(nip)), '') IS NULL
)

INSERT INTO dq_wyniki

SELECT
    'DQ-COMP-001' AS Rule_ID,
    'Kompletność' AS Wymiar_jakości,
    'kontrahenci' AS Nazwa_tabeli,
    'Brakujące wartości w kolumnie NIP' AS Opis_reguły,
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_COMP_001;


-- DQ-COMP-005 | srodki_trwale | brak numeru inwentarzowego | 
WITH DQ_COMP_005 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM srodki_trwale) AS Liczba_rekordów,
        CAST(100.0 * COUNT(*) / (SELECT COUNT(*) FROM srodki_trwale) AS DECIMAL(5,2)) AS Procentowy_udział_błędów
    FROM srodki_trwale
    WHERE NULLIF(LTRIM(RTRIM(numer_inwentarzowy)), '') IS NULL
)

INSERT INTO dq_wyniki

SELECT
    'DQ-COMP-005', 'Kompletność', 'srodki_trwale',
    'Brakujące wartości w kolumnie numer_inwentarzowy',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_COMP_005;


-- DQ-COMP-006 | srodki_trwale | brak stawki amortyzacji |
WITH DQ_COMP_006 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM srodki_trwale) AS Liczba_rekordów,
        CAST(100.0 * COUNT(*) / (SELECT COUNT(*) FROM srodki_trwale) AS DECIMAL(5,2)) AS Procentowy_udział_błędów
    FROM srodki_trwale
    WHERE NULLIF(LTRIM(RTRIM(CAST(stawka_amortyzacji AS varchar(10)))), '') IS NULL
)

INSERT INTO dq_wyniki

SELECT
    'DQ-COMP-006', 'Kompletność', 'srodki_trwale',
    'Brakujące wartości w kolumnie stawka_amortyzacji',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_COMP_006;


-- DQ-UNIQ-001 | kontrahenci | duplikaty NIP |
WITH DQ_UNIQ_001 AS (
    SELECT
        ISNULL(SUM(liczba_wystąpień - 1), 0) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * ISNULL(SUM(liczba_wystąpień - 1), 0)
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM (
        SELECT nip, COUNT(*) AS liczba_wystąpień
        FROM kontrahenci
        WHERE NULLIF(LTRIM(RTRIM(nip)), '') IS NOT NULL
        GROUP BY nip 
        HAVING COUNT(*) > 1
    ) AS temp_table
)

INSERT INTO dq_wyniki

SELECT
    'DQ-UNIQ-001', 'Unikalność', 'kontrahenci', 'Zduplikowane wartości NIP',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_UNIQ_001;


-- DQ-UNIQ-002 | kontrahenci | duplikaty REGON |
WITH DQ_UNIQ_002 AS (
    SELECT
        ISNULL(SUM(liczba_wystąpień - 1), 0) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * ISNULL(SUM(liczba_wystąpień - 1), 0)
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM (
        SELECT regon, COUNT(*) AS liczba_wystąpień
        FROM kontrahenci
        WHERE NULLIF(LTRIM(RTRIM(regon)), '') IS NOT NULL
        GROUP BY regon HAVING COUNT(*) > 1
    ) AS d
)

INSERT INTO dq_wyniki

SELECT
    'DQ-UNIQ-002', 'Unikalność', 'kontrahenci', 'Zduplikowane wartości REGON',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_UNIQ_002;


-- DQ-UNIQ-003 | produkty | duplikaty indeksu |
WITH DQ_UNIQ_003 AS (
    SELECT
        ISNULL(SUM(liczba_wystąpień - 1), 0) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * ISNULL(SUM(liczba_wystąpień - 1), 0)
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM (
        SELECT indeks, COUNT(*) AS liczba_wystąpień
        FROM produkty
        WHERE NULLIF(LTRIM(RTRIM(indeks)), '') IS NOT NULL
        GROUP BY indeks HAVING COUNT(*) > 1
    ) AS d
)

INSERT INTO dq_wyniki

SELECT
    'DQ-UNIQ-003', 'Unikalność', 'produkty', 'Zduplikowane wartości indeksu',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_UNIQ_003;


-- DQ-UNIQ-004 | produkty | duplikaty EAN |
WITH DQ_UNIQ_4 AS (
    SELECT
        ISNULL(SUM(liczba_wystąpień - 1), 0) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * ISNULL(SUM(liczba_wystąpień - 1), 0)
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM (
        SELECT ean, COUNT(*) AS liczba_wystąpień
        FROM produkty
        WHERE NULLIF(LTRIM(RTRIM(ean)), '') IS NOT NULL
        GROUP BY ean HAVING COUNT(*) > 1
    ) AS d
)

INSERT INTO dq_wyniki

SELECT
    'DQ-UNIQ-004', 'Unikalność', 'produkty', 'Zduplikowane wartości EAN',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_UNIQ_4;


-- DQ-UNIQ-005 | umowy | duplikaty numeru umowy |
WITH DQ_UNIQ_5 AS (
    SELECT
        ISNULL(SUM(liczba_wystąpień - 1), 0) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM umowy) AS Liczba_rekordów,
        CAST(
            100.0 * ISNULL(SUM(liczba_wystąpień - 1), 0)
            / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM (
        SELECT numer_umowy, COUNT(*) AS liczba_wystąpień
        FROM umowy
        WHERE NULLIF(LTRIM(RTRIM(numer_umowy)), '') IS NOT NULL
        GROUP BY numer_umowy HAVING COUNT(*) > 1
    ) AS d
)

INSERT INTO dq_wyniki

SELECT
    'DQ-UNIQ-005', 'Unikalność', 'umowy', 'Zduplikowane numery umowy',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_UNIQ_5;


-- DQ-UNIQ-006 | crm_kontakty | duplikaty (kontrahent_id + email) 
WITH DQ_UNIQ_6 AS (
    SELECT
        ISNULL(SUM(liczba_wystąpień - 1), 0) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM crm_kontakty) AS Liczba_rekordów,
        CAST(
            100.0 * ISNULL(SUM(liczba_wystąpień - 1), 0)
            / (SELECT COUNT(*) FROM crm_kontakty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM (
        SELECT kontrahent_id, email, COUNT(*) AS liczba_wystąpień
        FROM crm_kontakty
        WHERE NULLIF(LTRIM(RTRIM(email)), '') IS NOT NULL
        GROUP BY kontrahent_id, email HAVING COUNT(*) > 1
    ) AS d
)

INSERT INTO dq_wyniki

SELECT
    'DQ-UNIQ-006', 'Unikalność', 'crm_kontakty', 'Zduplikowany e-mail u tego samego kontrahenta',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_UNIQ_6;


-- DQ-UNIQ-007 | srodki_trwale | duplikaty numeru inwentarzowego |
WITH DQ_UNIQ_7 AS (
    SELECT
        ISNULL(SUM(liczba_wystąpień - 1), 0) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM srodki_trwale) AS Liczba_rekordów,
        CAST(
            100.0 * ISNULL(SUM(liczba_wystąpień - 1), 0)
            / (SELECT COUNT(*) FROM srodki_trwale) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM (
        SELECT numer_inwentarzowy, COUNT(*) AS liczba_wystąpień
        FROM srodki_trwale
        WHERE NULLIF(LTRIM(RTRIM(numer_inwentarzowy)), '') IS NOT NULL
        GROUP BY numer_inwentarzowy HAVING COUNT(*) > 1
    ) AS d
)

INSERT INTO dq_wyniki

SELECT
    'DQ-UNIQ-007', 'Unikalność', 'srodki_trwale', 'Zduplikowane numery inwentarzowe',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_UNIQ_7;


-- DQ-VALID-001 | kontrahenci | NIP zły format |
WITH DQ_VALID_1 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE NULLIF(RTRIM(LTRIM(nip)), '') IS NOT NULL
      AND (LEN(nip) <> 10 OR nip LIKE '%[^0-9]%')
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-001', 'Poprawność', 'kontrahenci', 'NIP w nieprawidłowym formacie',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_1;


-- DQ-VALID-002 | kontrahenci | REGON zły format |
WITH DQ_VALID_2 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE NULLIF(RTRIM(LTRIM(CAST(regon AS varchar(14)))), '') IS NOT NULL
      AND LEN(CAST(regon AS varchar(14))) NOT IN (9, 14)
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-002', 'Poprawność', 'kontrahenci', 'REGON w nieprawidłowym formacie',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_2;


-- DQ-VALID-003 | kontrahenci | kod pocztowy zły format |
WITH DQ_VALID_3 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE NULLIF(RTRIM(LTRIM(kod_pocztowy)), '') IS NOT NULL
      AND kod_pocztowy NOT LIKE '[0-9][0-9]-[0-9][0-9][0-9]'
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-003', 'Poprawność', 'kontrahenci', 'Kod pocztowy w formacie innym niż NN-NNN',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_3;


-- DQ-VALID-004 | kontrahenci | e-mail zły format |
WITH DQ_VALID_4 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE NULLIF(LTRIM(RTRIM(email)), '') IS NOT NULL
      AND email NOT LIKE '%_@_%._%'
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-004', 'Poprawność', 'kontrahenci', 'E-mail w nieprawidłowym formacie',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_4;


-- DQ-VALID-005 | kontrahenci | telefon zła długość |
WITH DQ_VALID_5 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE NULLIF(RTRIM(LTRIM(telefon)), '') IS NOT NULL
      AND LEN(telefon) <> 16
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-005', 'Poprawność', 'kontrahenci', 'Telefon o długości innej niż 16 znaków',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_5;


-- DQ-VALID-006 | kontrahenci | typ spoza słownika |
WITH DQ_VALID_6 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE typ NOT IN ('klient', 'dostawca', 'oba')
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-006', 'Poprawność', 'kontrahenci', 'Typ kontrahenta spoza słownika',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_6;


-- DQ-VALID-007 | kontrahenci | status spoza słownika |
WITH DQ_VALID_7 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE status NOT IN ('aktywny', 'nieaktywny')
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-007', 'Poprawność', 'kontrahenci', 'Status kontrahenta spoza słownika',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_7;


-- DQ-VALID-008 | produkty | kategoria spoza słownika |
WITH DQ_VALID_8 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE NULLIF(RTRIM(LTRIM(kategoria)), '') IS NOT NULL
      AND kategoria NOT IN ('Materiały zużywalne','Aparatura','Szkło laboratoryjne',
                            'Sprzęt laboratoryjny','Podłoża mikrobiologiczne','Odczynniki')
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-008', 'Poprawność', 'produkty', 'Kategoria produktu spoza słownika',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_8;


-- DQ-VALID-009 | produkty | ujemna cena zakupu |
WITH DQ_VALID_9 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE cena_zakupu < 0
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-009', 'Poprawność', 'produkty', 'Ujemna cena zakupu',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_9;


-- DQ-VALID-010 | produkty | ujemna cena sprzedaży |
WITH DQ_VALID_10 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE cena_sprzedazy < 0
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-010', 'Poprawność', 'produkty', 'Ujemna cena sprzedaży',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_10;


-- DQ-VALID-011 | produkty | EAN zły format |
WITH DQ_VALID_11 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE NULLIF(LTRIM(RTRIM(ean)), '') IS NOT NULL
      AND (LEN(ean) <> 13 OR ean LIKE '%[^0-9]%')   -- nawiasy: (długość LUB nie-cyfry)
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-011', 'Poprawność', 'produkty', 'EAN w nieprawidłowym formacie',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_11;


-- DQ-VALID-012 | produkty | status spoza słownika |
WITH DQ_VALID_12 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE NULLIF(LTRIM(RTRIM(status)), '') IS NOT NULL
      AND status NOT IN ('aktywny', 'nieaktywny')
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-012', 'Poprawność', 'produkty', 'Status produktu spoza słownika',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_12;


-- DQ-VALID-013 | produkty | cena_zakupu >= cena_sprzedazy |
WITH DQ_VALID_13 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE cena_zakupu >= cena_sprzedazy
)

INSERT INTO dq_wyniki

SELECT
    'DQ-VALID-013', 'Reguła biznesowa', 'produkty', 'Cena sprzedaży nie wyższa od ceny zakupu',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_VALID_13;


-- DQ-CONS-001 | kontrahenci | słownik kraju |
WITH DQ_CONS_1 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE NULLIF(RTRIM(LTRIM(kraj)), '') IS NULL
       OR  kraj COLLATE Latin1_General_CS_AS <> 'PL'
)

INSERT INTO dq_wyniki

SELECT
    'DQ-CONS-001', 'Spójność', 'kontrahenci', 'Niespójny zapis kraju',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_CONS_1;


-- DQ-CONS-005 | produkty | słownik jednostki  |
WITH DQ_CONS_5 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE jednostka_miary COLLATE Latin1_General_CS_AS <> 'szt'  
       OR jednostka_miary LIKE '% ' OR jednostka_miary LIKE ' %'
)

INSERT INTO dq_wyniki

SELECT
    'DQ-CONS-005', 'Spójność', 'produkty', 'Niespójny zapis jednostki miary',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_CONS_5;


-- DQ-CONS-006 | produkty | zapis stawki VAT |
WITH DQ_CONS_6 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE NULLIF(RTRIM(LTRIM(stawka_vat)), '') IS NOT NULL
        AND stawka_vat <> '23'
)

INSERT INTO dq_wyniki

SELECT
    'DQ-CONS-006', 'Spójność', 'produkty', 'Niespójny zapis stawki VAT',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_CONS_6;


-- DQ-CONS-007 | umowy | słownik waluty |
WITH DQ_CONS_7 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM umowy) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM umowy
    WHERE NULLIF(RTRIM(LTRIM(waluta)), '') IS NOT NULL
      AND (waluta COLLATE Latin1_General_CS_AS <> 'PLN'
        OR waluta LIKE '% ' OR waluta LIKE ' %' )
)

INSERT INTO dq_wyniki

SELECT
    'DQ-CONS-007', 'Spójność', 'umowy', 'Niespójny zapis waluty',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_CONS_7;


-- DQ-REF-001 | umowy -> kontrahenci |
WITH DQ_REF_1 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM umowy) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM umowy AS u
    LEFT JOIN kontrahenci AS k 
        ON u.kontrahent_id = k.kontrahent_id
    WHERE k.kontrahent_id IS NULL
        AND u.kontrahent_id IS NOT NULL
)

INSERT INTO dq_wyniki

SELECT
    'DQ-REF-001', 'Integralność referencyjna', 'umowy', 'Umowa wskazuje nieistniejącego kontrahenta',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_REF_1;


-- DQ-REF-002 | crm_kontakty -> kontrahenci |
WITH DQ_REF_2 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM crm_kontakty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM crm_kontakty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM crm_kontakty AS c
    LEFT JOIN kontrahenci AS k 
        ON c.kontrahent_id = k.kontrahent_id
    WHERE k.kontrahent_id IS NULL
        AND c.kontrahent_id IS NOT NULL
)

INSERT INTO dq_wyniki

SELECT
    'DQ-REF-002', 'Integralność referencyjna', 'crm_kontakty', 'Kontakt wskazuje nieistniejącego kontrahenta',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_REF_2;


-- DQ-REF-003 | srodki_trwale -> kontrahenci |
WITH DQ_REF_3 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM srodki_trwale) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM srodki_trwale) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM srodki_trwale AS s
    LEFT JOIN kontrahenci AS k 
        ON s.dostawca_id = k.kontrahent_id
    WHERE k.kontrahent_id IS NULL
        AND s.dostawca_id IS NOT NULL
)

INSERT INTO dq_wyniki

SELECT
    'DQ-REF-003', 'Integralność referencyjna', 'srodki_trwale', 'Środek trwały wskazuje nieistniejącego dostawcę',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_REF_3;


-- DQ-TIME-001 | kontrahenci | data_utworzenia z przyszłości |
WITH DQ_TIME_1 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM kontrahenci) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM kontrahenci
    WHERE TRY_CAST(data_utworzenia AS date) > CAST(GETDATE() AS date)
)

INSERT INTO dq_wyniki

SELECT
    'DQ-TIME-001', 'Aktualność', 'kontrahenci', 'Data utworzenia z przyszłości',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_TIME_1;


-- DQ-TIME-002 | produkty | data_utworzenia z przyszłości |
WITH DQ_TIME_2 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM produkty) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM produkty
    WHERE TRY_CAST(data_utworzenia AS date) > CAST(GETDATE() AS date)
)

INSERT INTO dq_wyniki

SELECT
    'DQ-TIME-002', 'Aktualność', 'produkty', 'Data utworzenia z przyszłości',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_TIME_2;


-- DQ-TIME-003 | umowy | data_podpisania > data_rozpoczecia |
WITH DQ_TIME_3 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM umowy) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM umowy
    WHERE TRY_CAST(data_podpisania AS date) > TRY_CAST(data_rozpoczecia AS date)
)

INSERT INTO dq_wyniki

SELECT
    'DQ-TIME-003', 'Aktualność', 'umowy', 'Data podpisania późniejsza niż rozpoczęcia',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_TIME_3;


-- DQ-TIME-004 | umowy | data_rozpoczecia > data_zakonczenia |
WITH DQ_TIME_4 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM umowy) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM umowy
    WHERE TRY_CAST(data_rozpoczecia AS date) > TRY_CAST(data_zakonczenia AS date)
)

INSERT INTO dq_wyniki

SELECT
    'DQ-TIME-004', 'Aktualność', 'umowy', 'Data rozpoczęcia późniejsza niż zakończenia',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_TIME_4;


-- DQ-TIME-005 | umowy | data_podpisania z przyszłości |
WITH DQ_TIME_5 AS (
    SELECT
        COUNT(*) AS Liczba_naruszeń,
        (SELECT COUNT(*) FROM umowy) AS Liczba_rekordów,
        CAST(
            100.0 * COUNT(*) 
            / (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
        ) AS Procentowy_udział_błędów
    FROM umowy
    WHERE TRY_CAST(data_podpisania AS date) > CAST(GETDATE() AS date)
)

INSERT INTO dq_wyniki

SELECT
    'DQ-TIME-005', 'Aktualność', 'umowy', 'Data podpisania z przyszłości',
    Liczba_naruszeń, Liczba_rekordów, Procentowy_udział_błędów
FROM DQ_TIME_5;

SELECT * FROM dq_wyniki

