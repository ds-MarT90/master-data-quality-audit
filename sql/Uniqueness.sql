
------------------------- Wymiary jakości danych ------------------------------
                          -- Unikalność --

/* Cel:
   Ocena unikalności danych w kluczowych tabelach systemu.

   Opis:
   Unikalność określa, czy wartości, które powinny występować tylko raz,
   nie pojawiają się wielokrotnie. Duplikaty mogą prowadzić do błędnych analiz,
   niepoprawnego raportowania oraz problemów w procesach biznesowych. */


/* ============================================================================
   Rule ID: DQ-UNIQ-001
    
   Nazwa: Unikalność danych w tabeli kontrahenci, numer nip.

============================================================================ */

SELECT
	nip,
	COUNT(*) AS liczba_wystąpień
FROM kontrahenci
WHERE NULLIF(LTRIM(RTRIM(nip)),'') IS NOT NULL
GROUP BY nip
HAVING COUNT(*) > 1;


WITH duplikaty_nip AS(

	SELECT
		nip,
		COUNT(*) AS liczba_wystąpień
	FROM kontrahenci
	WHERE NULLIF(LTRIM(RTRIM(nip)),'') IS NOT NULL
	GROUP BY nip
	HAVING COUNT(*) > 1
)

SELECT 
	SUM(liczba_wystąpień - 1) AS ilosc_duplikatów,

	(SELECT COUNT(*) 
	FROM kontrahenci
	) AS wszystkie_wiersze,

	CAST(
		100.0 * SUM(liczba_wystąpień - 1)
		/
		(SELECT COUNT(*) FROM kontrahenci) AS DECIMAL(5,2)
		) AS procent_duplikatów_nip

FROM duplikaty_nip;

/* ============================================================================
   Rule ID: DQ-UNIQ-002
    
   Nazwa: Unikalność danych w tabeli kontrahenci, numer regon.

============================================================================ */

SELECT
	regon,
	COUNT(*) AS liczba_wystąpień
FROM kontrahenci
WHERE NULLIF(LTRIM(RTRIM(regon)), '') IS NOT NULL
GROUP BY regon
HAVING COUNT(*) > 1;

WITH duplikaty_regon AS(
	
	SELECT
		regon,
		COUNT(*) AS liczba_wystąpień
	FROM kontrahenci
	WHERE NULLIF(LTRIM(RTRIM(regon)), '') IS NOT NULL
	GROUP BY regon
	HAVING COUNT(*) > 1
)

SELECT SUM(liczba_wystąpień - 1) AS ilość_duplikatów,

(SELECT COUNT(*)
 FROM kontrahenci
) AS wszystkie_wiersze,

CAST(
	100.0 * SUM(liczba_wystąpień - 1)
	/
	(SELECT COUNT(*) FROM kontrahenci) AS DECIMAL (5,2)
) AS procent_duplikatów_regon

FROM duplikaty_regon;


/* ============================================================================
   Rule ID: DQ-UNIQ-003
    
   Nazwa: Unikalność danych w tabeli produkty, numer indeksu

============================================================================ */

SELECT
	indeks,
	COUNT(*) AS liczba_wystąpień,
	COUNT(*) - 1 AS liczba_duplikatów
FROM produkty
WHERE NULLIF(LTRIM(RTRIM(indeks)), '') IS NOT NULL
GROUP BY indeks
HAVING COUNT(*) > 1;

WITH tabela_duplikaty AS(
	SELECT
		indeks,
		COUNT(*) AS liczba_wystąpień,
		COUNT(*) - 1 AS liczba_duplikatów
	FROM produkty
	WHERE NULLIF(LTRIM(RTRIM(indeks)), '') IS NOT NULL
	GROUP BY indeks
	HAVING COUNT(*) > 1
)

SELECT 
	(SELECT COUNT(*) FROM produkty) AS wszystkie_wiersze,
	SUM(liczba_wystąpień - 1) AS liczba_duplikatów,
	CAST(
		100.0 * SUM(liczba_duplikatów)
		/ (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
	) AS procent_zduplikowanych_indeksów
	

FROM tabela_duplikaty;


/* ============================================================================
   Rule ID: DQ-UNIQ-004
    
   Nazwa: Unikalność danych w tabeli produkty, numer ean

============================================================================ */

SELECT
	ean,
	COUNT(*) AS liczba_wystąpień,
	COUNT(*) - 1 AS liczba_duplikatów
FROM produkty
WHERE NULLIF(LTRIM(RTRIM(ean)), '') IS NOT NULL
GROUP BY ean
HAVING COUNT(*) > 1;

WITH tabela_duplikaty AS(
	SELECT
		ean,
		COUNT(*) AS liczba_wystąpień,
		COUNT(*) - 1 AS liczba_duplikatów
	FROM produkty
	WHERE NULLIF(LTRIM(RTRIM(ean)), '') IS NOT NULL
	GROUP BY ean
	HAVING COUNT(*) > 1
)

SELECT 
	(SELECT COUNT(*) FROM produkty) AS wszystkie_wiersze,
	SUM(liczba_wystąpień - 1) AS liczba_duplikatów,
	CAST(
		100.0 * SUM(liczba_duplikatów)
		/ (SELECT COUNT(*) FROM produkty) AS DECIMAL(5,2)
	) AS procent_zduplikowanych_ean
	

FROM tabela_duplikaty;


/* ============================================================================
   Rule ID: DQ-UNIQ-005
    
   Nazwa: Unikalność danych w tabeli umowy, numer umowy

============================================================================ */

SELECT
	numer_umowy,
	COUNT(*) AS liczba_wystąpień,
	COUNT(*) - 1 AS liczba_duplikatów
FROM umowy
WHERE NULLIF(LTRIM(RTRIM(numer_umowy)), '') IS NOT NULL
GROUP BY numer_umowy
HAVING COUNT(*) > 1;


WITH tabela_duplikaty AS(
	SELECT
		numer_umowy,
		COUNT(*) AS liczba_wystąpień,
		COUNT(*) - 1 AS liczba_duplikatów
	FROM umowy
	WHERE NULLIF(LTRIM(RTRIM(numer_umowy)), '') IS NOT NULL
	GROUP BY numer_umowy
	HAVING COUNT(*) > 1
)

SELECT 
	(SELECT COUNT(*) FROM umowy) AS wszystkie_wiersze,
	SUM(liczba_wystąpień - 1) AS liczba_duplikatów,
	CAST(
		100.0 * SUM(liczba_duplikatów)
		/ (SELECT COUNT(*) FROM umowy) AS DECIMAL(5,2)
	) AS procent_zduplikowanych_numerów_umowy
	

FROM tabela_duplikaty;



/* ============================================================================
   Rule ID: DQ-UNIQ-006
    
   Nazwa: Unikalność danych w tabeli crm_kontakty, kontrahent_id + email

============================================================================ */

SELECT
	kontrahent_id,
	email,
	COUNT(*) AS liczba_wystąpień,
	COUNT(*) - 1 AS liczba_duplikatów
FROM crm_kontakty
WHERE NULLIF(LTRIM(RTRIM(email)), '') IS NOT NULL
GROUP BY kontrahent_id,email
HAVING COUNT(*) > 1;

WITH tabela_duplikaty AS(
	SELECT
		kontrahent_id,
		email,
		COUNT(*) AS liczba_wystąpień,
		COUNT(*) - 1 AS liczba_duplikatów
	FROM crm_kontakty
	WHERE NULLIF(LTRIM(RTRIM(email)), '') IS NOT NULL
	GROUP BY kontrahent_id,email
	HAVING COUNT(*) > 1
)

SELECT 
	(SELECT COUNT(*) FROM crm_kontakty) AS wszystkie_wiersze,
	SUM(liczba_wystąpień - 1) AS liczba_duplikatów,
	CAST(
		100.0 * SUM(liczba_duplikatów)
		/ (SELECT COUNT(*) FROM crm_kontakty) AS DECIMAL(5,2)
	) AS procent_zduplikowanych_kontaktów
	

FROM tabela_duplikaty;


/* ============================================================================
   Rule ID: DQ-UNIQ-007
    
   Nazwa: Unikalność danych w tabeli srodki_trwale, numer_inwentarzowy

============================================================================ */ 


SELECT
	numer_inwentarzowy,
	COUNT(*) AS liczba_wystąpień,
	COUNT(*) - 1 AS liczba_duplikatów
FROM srodki_trwale
WHERE NULLIF(LTRIM(RTRIM(numer_inwentarzowy)), '') IS NOT NULL
GROUP BY numer_inwentarzowy
HAVING COUNT(*) > 1;

WITH tabela_duplikaty AS(
	SELECT
		numer_inwentarzowy,
		COUNT(*) AS liczba_wystąpień,
		COUNT(*) - 1 AS liczba_duplikatów
	FROM srodki_trwale
	WHERE NULLIF(LTRIM(RTRIM(numer_inwentarzowy)), '') IS NOT NULL
	GROUP BY numer_inwentarzowy
	HAVING COUNT(*) > 1
)

SELECT 
	(SELECT COUNT(*) FROM crm_kontakty) AS wszystkie_wiersze,
	SUM(liczba_wystąpień - 1) AS liczba_duplikatów,
	CAST(
		100.0 * SUM(liczba_duplikatów)
		/ (SELECT COUNT(*) FROM crm_kontakty) AS DECIMAL(5,2)
	) AS procent_zduplikowanych_numerów_inwentarzowych
	

FROM tabela_duplikaty;