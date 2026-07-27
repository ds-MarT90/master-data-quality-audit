# Jakość danych podstawowych — audyt w SQL i dashboard w Power BI

![SQL Server](https://img.shields.io/badge/MS_SQL_Server-CC2927?style=flat-square&logo=microsoftsqlserver&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-003B57?style=flat-square)
![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=flat-square&logo=powerbi&logoColor=black)
![Power Query](https://img.shields.io/badge/Power_Query-107C41?style=flat-square)

Kompletny projekt jakości danych: od surowego, „brudnego" eksportu z ERP/CRM,
przez profilowanie i reguły napisane w **SQL**, po scorecard KPI oraz interaktywny
**dashboard w Power BI**, który pozwala zejść do pojedynczego rekordu.

> **Dane w tym repozytorium są syntetyczne** (wygenerowane na potrzeby projektu).
> Nie zawierają żadnych rzeczywistych informacji o firmach ani osobach.

<p align="center">
  <img src="docs/dashboard_przeglad.png" alt="Dashboard Power BI — strona przeglądu" width="90%">
</p>

## Problem

Dane podstawowe (kontrahenci, produkty, umowy, kontakty CRM, środki trwałe) rzadko
są idealne: duplikaty NIP-ów, niespójne słowniki (`PL` / `Polska` / `Poland`),
rekordy wskazujące na nieistniejącego kontrahenta oraz daty łamiące chronologię.
Takie błędy po cichu psują raporty i procesy.

Celem projektu było **zmierzenie** stanu danych, **wskazanie konkretnych rekordów**
do poprawy oraz **podział problemów** na dwie grupy: te, które można wyczyścić
automatycznie, i te, które trzeba naprawić u źródła.

## Dane

Pięć powiązanych tabel w formacie CSV (dane podstawowe):

| Tabela | Znaczenie | Liczba wierszy |
|---|---|---|
| `kontrahenci` | kontrahenci | 2 120 |
| `produkty` | produkty | 1 200 |
| `umowy` | umowy | 3 500 |
| `crm_kontakty` | kontakty CRM | 3 090 |
| `srodki_trwale` | środki trwałe | 600 |

## Reguły jakości

Napisałem **35 reguł w T-SQL**, pogrupowanych w sześć wymiarów jakości. Każda reguła
ma `Rule ID`, opis i zwraca zarówno listę błędnych rekordów, jak i procent naruszeń.

| Wymiar | Reguły | Przykłady |
|---|---|---|
| Kompletność | 3 | braki NIP, numeru inwentarzowego, stawki amortyzacji |
| Unikalność | 7 | duplikaty NIP / REGON / indeksu / numeru umowy |
| Poprawność | 12 | format NIP, kodu pocztowego, e-maila, EAN; ujemne ceny |
| Spójność | 4 | słowniki: kraj, waluta, jednostka miary, stawka VAT |
| Integralność referencyjna | 3 | rekordy osierocone (umowy, CRM, środki → kontrahenci) |
| Aktualność | 5 | daty z przyszłości, błędna kolejność dat umów |
| Reguła biznesowa | 1 | marża: cena sprzedaży ≥ cena zakupu |

## Co zrobiłem

1. **Profilowanie.** Zmierzyłem kompletność, duplikaty, formaty i zakresy wartości
   zanim napisałem jakąkolwiek regułę — najpierw liczby, potem wnioski.
2. **Reguły w SQL.** Zbudowałem po jednym zapytaniu na regułę, używając wzorców
   takich jak `GROUP BY ... HAVING COUNT(*) > 1` (duplikaty),
   `LEFT JOIN ... WHERE klucz IS NULL` (rekordy osierocone) oraz bezpiecznego
   rzutowania dat przez `TRY_CAST`.
3. **Scorecard.** Połączyłem wszystkie reguły w jedną tabelę wynikową (`dq_wyniki`),
   tak by każda reguła stała się jednym wierszem: wymiar, tabela, liczba naruszeń
   i procent błędów.
4. **Dashboard w Power BI.** Podłączyłem scorecard i zbudowałem dwie strony:
   przegląd z KPI i wykresami oraz stronę szczegółów dostępną przez drążenie
   (drill-through).

## Kluczowe wyniki

- **Ogólny wskaźnik jakości ~97%** — wysoki jako średnia, ale maskuje, gdzie
  naprawdę leżą problemy.
- **Tabela `kontrahenci` to epicentrum.** Jako dane podstawowe jest „rodzicem" umów,
  CRM i środków, więc błąd tutaj promieniuje na całą organizację.
- **Najsłabszy wymiar to spójność** — niespójne słowniki kraju, waluty, jednostki
  miary i stawki VAT.
- Wykryto **304 rekordy osierocone** (naruszone relacje) oraz **240 duplikatów**
  NIP i REGON.

### Główny wniosek: korekta vs prewencja

Naruszenia podzieliłem na dwie grupy, bo wymagają różnych działań:

- **Do automatycznego czyszczenia (Power Query):** ta sama wartość zapisana na różne
  sposoby — kraj, waluta, jednostka, VAT, format kodu pocztowego, NIP z myślnikami.
- **Do prewencji u źródła (walidacja w ERP):** realne błędy, których czyszczenie nie
  wymyśli — braki NIP, duplikaty, rekordy osierocone, ujemna marża, błędna
  kolejność dat.

Ten podział zamienia listę błędów w konkretny plan działania.

## Dashboard

- **Strona przeglądu:** KPI (wskaźnik jakości, liczba reguł, liczba naruszeń),
  naruszenia wg wymiaru / tabeli / reguły oraz fragmentatory.
- **Strona szczegółów:** tabela reguł z warunkowym (czerwonym) formatowaniem,
  otwierana przez **drill-through** z wykresów.

<p align="center">
  <img src="docs/dashboard_szczegoly.png" alt="Dashboard Power BI — strona szczegółów" width="90%">
</p>

## Jak uruchomić

1. Zaimportuj pliki CSV z `data/` do MS SQL Server (np. przez SSMS).
2. Uruchom pliki z `sql/`, aby zobaczyć błędne rekordy i procenty naruszeń.
3. Uruchom `CREATE_TABLE.sql`, a następnie `Dashboard_results.sql`, aby zbudować
   tabelę scorecard `dq_wyniki`.
4. Otwórz `powerbi/dashboard_jakosci.pbix` i odśwież źródło danych.

## Technologie

· MS SQL Server · Power BI · 

## Autor

Marcin Tylutki · GitHub: [ds-MarT90](https://github.com/ds-MarT90) ·
[LinkedIn](https://www.linkedin.com/in/marcin-tylutki/)
