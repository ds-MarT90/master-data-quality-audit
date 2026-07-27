
------------------------- Wymiary jakości danych ------------------------------
                          -- Kompletność --

/* Cel:
   Ocena kompletności danych w kluczowych tabelach systemu.

   Opis:
   Kompletność określa, czy wymagane dane zostały uzupełnione.
   Brakujące wartości mogą uniemożliwiać analizę danych,
   raportowanie oraz poprawne działanie procesów biznesowych. */


/* ============================================================================
   Rule ID: DQ-COMP-001
    
   Nazwa: Kompletność danych kontrahentów

============================================================================ */

SELECT
    COUNT(*) AS liczba_rekordow,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(nazwa)), '')           IS NULL THEN 1 ELSE 0 END) AS brak_nazwy,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(nip)), '')             IS NULL THEN 1 ELSE 0 END) AS brak_nip,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(regon)), '')           IS NULL THEN 1 ELSE 0 END) AS brak_regon,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(kraj)), '')            IS NULL THEN 1 ELSE 0 END) AS brak_kraju,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(miasto)), '')          IS NULL THEN 1 ELSE 0 END) AS brak_miasta,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(kod_pocztowy)), '')    IS NULL THEN 1 ELSE 0 END) AS brak_kodu_pocztowego,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(ulica)), '')           IS NULL THEN 1 ELSE 0 END) AS brak_ulicy,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(email)), '')           IS NULL THEN 1 ELSE 0 END) AS brak_adresu_email,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(telefon)), '')         IS NULL THEN 1 ELSE 0 END) AS brak_telefonu,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(status)), '')          IS NULL THEN 1 ELSE 0 END) AS brak_statusu

FROM kontrahenci;

-- %brakującyh wartości w kolumnie nip --
SELECT
    COUNT(*) AS liczba_rekordów,
    CAST(
        100.0 * SUM(CASE WHEN NULLIF(LTRIM(RTRIM(nip)), '') IS NULL THEN 1 ELSE 0 END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS proc_brak_nip

FROM kontrahenci;

/* ============================================================================
   Rule ID: DQ-COMP-002
    
   Nazwa: Kompletność danych produktów

============================================================================ */

SELECT
    COUNT(*) AS liczba_rekordow,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(indeks)), '')          IS NULL THEN 1 ELSE 0 END) AS brak_indeksu,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(nazwa)), '')           IS NULL THEN 1 ELSE 0 END) AS brak_nazwy,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(producent)), '')       IS NULL THEN 1 ELSE 0 END) AS brak_producenta,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(jednostka_miary)), '') IS NULL THEN 1 ELSE 0 END) AS brak_jednostki,

    SUM(CASE WHEN stawka_vat IS NULL THEN 1 ELSE 0 END) AS brak_vat,

    SUM(CASE WHEN cena_zakupu IS NULL THEN 1 ELSE 0 END) AS brak_ceny_zakupu,

    SUM(CASE WHEN cena_sprzedazy IS NULL THEN 1 ELSE 0 END) AS brak_ceny_sprzedazy

FROM produkty;

/* ============================================================================
   Rule ID: DQ-COMP-003

   Nazwa: Kompletność danych umów

============================================================================ */

SELECT
    COUNT(*) AS liczba_rekordow,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(numer_umowy)), '')      IS NULL THEN 1 ELSE 0 END) AS brak_numeru,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(opiekun)), '')          IS NULL THEN 1 ELSE 0 END) AS brak_opiekuna,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(data_podpisania)), '')  IS NULL THEN 1 ELSE 0 END) AS brak_daty_podpisania,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(data_rozpoczecia)), '') IS NULL THEN 1 ELSE 0 END) AS brak_daty_rozpoczecia,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(waluta)), '')           IS NULL THEN 1 ELSE 0 END) AS brak_waluty,

    SUM(CASE WHEN kontrahent_id IS NULL THEN 1 ELSE 0 END) AS brak_kontrahenta

FROM umowy;

/* ============================================================================
   Rule ID: DQ-COMP-004

   Nazwa: Kompletność danych kontaktowych CRM

============================================================================ */

SELECT
    COUNT(*) AS liczba_rekordow,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(imie)), '')     IS NULL THEN 1 ELSE 0 END) AS brak_imienia,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(nazwisko)), '') IS NULL THEN 1 ELSE 0 END) AS brak_nazwiska,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(email)), '')    IS NULL THEN 1 ELSE 0 END) AS brak_email,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(telefon)), '')  IS NULL THEN 1 ELSE 0 END) AS brak_telefonu

FROM crm_kontakty;


/* ============================================================================
   Rule ID: DQ-COMP-005

   Nazwa: Kompletność danych środków trwałych

============================================================================ */

SELECT
    COUNT(*) AS liczba_rekordow,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(nazwa)), '')                                     IS NULL THEN 1 ELSE 0 END) AS brak_nazwy,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(numer_inwentarzowy)), '')                        IS NULL THEN 1 ELSE 0 END) AS brak_numeru_inwentarzowego,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(data_przyjecia)), '')                            IS NULL THEN 1 ELSE 0 END) AS brak_daty,

    SUM(CASE WHEN NULLIF(LTRIM(RTRIM(CAST(stawka_amortyzacji AS varchar (10)))), '')  IS NULL THEN 1 ELSE 0 END) AS brak_stawki_amortyzacji,

    SUM(CASE WHEN dostawca_id IS NULL THEN 1 ELSE 0 END) AS brak_dostawcy

FROM srodki_trwale;

-- %brakującyh wartości w kolumnie numer_inwentarzowy --

SELECT
    COUNT(*) AS liczba_rekordów,
    CAST(
        100.0 * SUM(CASE WHEN NULLIF(LTRIM(RTRIM(numer_inwentarzowy)), '') IS NULL THEN 1 ELSE 0 END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS proc_brak_numeru_inwentarzowego,

     CAST(
        100.0 * SUM(CASE WHEN NULLIF(LTRIM(RTRIM(stawka_amortyzacji)), '') IS NULL THEN 1 ELSE 0 END)
        / COUNT(*)
        AS DECIMAL(5,2)
    ) AS proc_brak_stawki_amortyzacji


FROM srodki_trwale;



