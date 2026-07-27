# Przewodnik projektu: System monitorowania i poprawy jakości danych podstawowych

Projekt portfolio dopasowany do stanowiska **Specjalista ds. Danych Podstawowych
i Jakości Danych**. Prowadzi Cię od surowego, „brudnego" eksportu z ERP/CRM aż do
gotowego dashboardu w Power BI oraz lekkiego frameworku data governance.

**Dla kogo:** osoba po kursach z Excela, podstaw Power Query, SQL jako narzędzia
analitycznego (nie administracji bazą) i Power BI, znająca odrobinę Pythona.

**Ile zajmie:** realnie 12–20 godzin pracy, rozłożone na etapy. Nie rób wszystkiego
naraz — każdy etap ma jasny efekt (deliverable), który sam w sobie jest wartościowy.

**Po co ten projekt:** odwzorowuje jeden do jednego zakres obowiązków z oferty —
standardy i reguły jakości, audyt danych, wskaźniki jakości, współpracę
SQL/Excel/BI wokół ERP/CRM oraz działania korygujące i prewencyjne. Po jego
ukończeniu możesz w rozmowie mówić konkretami zamiast ogólników.

---

## Mapowanie na ogłoszenie

| Obowiązek z oferty | Etap w projekcie |
|---|---|
| Zapewnienie jakości danych (produkty, kontrahenci, umowy, CRM, środki trwałe) | Etapy 2–5 |
| Monitorowanie i poprawa jakości, analiza błędów, działania korygujące i prewencyjne | Etapy 5, 7, 8 |
| Definiowanie ról, odpowiedzialności i procesów | Etap 7 |
| Audyty danych, raporty i wskaźniki jakości | Etapy 3, 6 |
| Współpraca z finansami/IT/BI | Etap 8 (prezentacja) |
| Udział w projektach automatyzujących i standaryzujących | Etapy 4, 5 (powtarzalny Power Query) |

---

## Architektura rozwiązania

```
ERP/CRM (CSV)  →  SQL (profilowanie + reguły)  →  Excel/Power Query (czyszczenie)  →  Power BI (KPI)
                          │                                                              ▲
                          └──────────  Python: walidacja NIP, duplikaty rozmyte  ────────┘
                                                     ↑
                          Prewencja: wnioski wracają do ERP (walidacja u źródła)
```

Zasada przewodnia: **jakość naprawia się u źródła**. Czyszczenie w Excelu leczy
objaw; reguła walidacyjna w ERP leczy przyczynę. Ten projekt pokazuje oba poziomy.

---

## Etap 0 — Przygotowanie środowiska

**Cel:** działające narzędzia i wczytane dane.

1. **Baza SQL.** Wybierz jedną ścieżkę:
   - **Ścieżka A (zalecana pod tę ofertę):** Microsoft SQL Server **Express**
     (darmowy) + **SSMS** (SQL Server Management Studio). To dokładnie środowisko
     Dynamics 365 / Comarch ERP XL — możesz potem napisać w CV, że pracowałeś
     na MS SQL / T-SQL.
   - **Ścieżka B (lżejsza):** **DuckDB** albo **SQLite** — instalacja w minutę,
     potrafi odpytywać pliki CSV niemal bez konfiguracji. Składnia różni się
     w detalach (np. brak `TRY_CONVERT` — użyj `TRY_CAST`).
2. **Excel** z zakładką **Dane → Pobierz i przekształć (Power Query)** — jest
   w każdej nowoczesnej wersji.
3. **Power BI Desktop** (darmowy, Microsoft Store).
4. **Python** (opcjonalnie) z pakietem `pandas`: `pip install pandas`.
5. **Dane.** Masz je już w folderze `dane/`. Jeśli chcesz je odtworzyć lub zmienić
   skalę problemów — uruchom `python/generuj_dane.py`.

**Deliverable:** działające SSMS/DuckDB z 5 wczytanymi tabelami `stg_*`
(uruchom `sql/01_tabele.sql`, potem zaimportuj CSV — instrukcja w komentarzu pliku).

---

## Etap 1 — Profilowanie danych (poznaj stan wyjściowy)

**Cel:** zanim ustalisz reguły, zrozum dane. Nie zgadujesz problemów — mierzysz je.

**Co zrobić:** uruchom `sql/03_profilowanie.sql` sekcja po sekcji i zanotuj wyniki:
- liczności tabel,
- kompletność kluczowych kolumn (ile braków NIP, e-maili, miast),
- rozkłady wartości słownikowych (`kraj`, `jednostka_miary`, `stawka_vat`,
  `waluta`) — tu zobaczysz niespójności typu `PL` / `Polska` / `Poland`,
- liczba wierszy vs liczba unikalnych indeksów produktu (różnica = duplikaty),
- zakres dat (czy nie ma z przyszłości / błędnych formatów).

**Ważna technika:** `NULLIF(LTRIM(RTRIM(kol)),'')` traktuje pusty tekst i spacje
tak samo jak brak — inaczej „puste" wartości umkną liczeniu.

**6 wymiarów jakości**, którymi opisujemy dane (zapamiętaj — to język tej roli):
kompletność, unikalność, poprawność (validity), spójność (consistency),
zgodność (accuracy), aktualność (timeliness).

**Deliverable:** krótki raport „stan zdrowia danych" (1 strona) — tabela
kolumna/wymiar/% problemów. To Twój punkt odniesienia „przed".

---

## Etap 2 — Definicja reguł jakości i KPI

**Cel:** zamienić obserwacje w mierzalne, powtarzalne reguły.

Dla każdego obszaru zapisz reguły w tabeli: **ID | reguła | wymiar | próg akceptacji |
działanie przy naruszeniu**. Przykłady (pełny zestaw zaimplementowany w SQL):

| ID | Reguła | Wymiar | Próg |
|---|---|---|---|
| R1 | Brak zduplikowanych NIP-ów | unikalność | 0 |
| R2 | Każdy kontrahent ma NIP | kompletność | ≥ 98% |
| R3 | NIP ma 10 cyfr i poprawną sumę kontrolną | poprawność | ≥ 98% |
| R4 | Każda umowa wskazuje istniejącego kontrahenta | spójność | 0 osieroconych |
| R5 | data_zakończenia ≥ data_rozpoczęcia | poprawność | 0 |
| R6 | cena_sprzedaży ≥ cena_zakupu oraz cena > 0 | reguła biznesowa | 0 |
| R7 | waluta ze słownika {PLN, EUR, USD} | spójność | 0 spoza |
| R8 | Unikalny indeks produktu i numer umowy | unikalność | 0 |

**Deliverable:** rejestr reguł (arkusz lub tabela w dokumencie). To dokładnie to,
co w ogłoszeniu nazwano „tworzenie standardów oraz zasad zarządzania danymi".

---

## Etap 3 — Audyt w SQL (znajdź naruszenia u źródła)

**Cel:** dla każdej reguły wygenerować (a) listę rekordów do poprawy i (b) liczbę
naruszeń do KPI.

**Co zrobić:** uruchom `sql/04_reguly_jakosci.sql`. Poznasz tam wzorce, które
w tej pracy będziesz stosować codziennie:
- **duplikaty:** `GROUP BY klucz HAVING COUNT(*) > 1`,
- **braki:** `WHERE NULLIF(...) IS NULL`,
- **integralność referencyjna:** `LEFT JOIN ... WHERE klucz IS NULL`
  (rekordy osierocone — umowy/środki/kontakty bez istniejącego kontrahenta),
- **reguły biznesowe:** porównania z `TRY_CONVERT` (bezpieczne rzutowanie dat/liczb),
- **deduplikacja z zachowaniem wzorca:** `ROW_NUMBER() OVER (PARTITION BY ...)` —
  `rn = 1` zostaje, `rn > 1` do scalenia,
- **scorecard (R10):** jedno zapytanie zwracające tabelę reguła/naruszenia/%OK,
  które później zasili Power BI.

**Weryfikacja:** porównaj swoje liczby z plikiem `dziennik_bledow.json` (klucz
odpowiedzi z liczbą celowo wprowadzonych problemów). Drobne różnice są normalne
i pouczające — np. duplikat utworzony z rekordu, który wcześniej dostał myślniki
w NIP, liczy się inaczej po normalizacji. Umiejętność wyjaśnienia takiej różnicy
to sygnał dojrzałości analitycznej.

**Deliverable:** komplet zapytań audytowych + scorecard. To „realizacja audytów
danych" z ogłoszenia.

---

## Etap 4 — Czyszczenie i standaryzacja w Power Query

**Cel:** zamienić wykryte problemy w **powtarzalny proces** czyszczenia (nie ręczne
poprawki). Power Query jest tu kluczowy — to on odróżnia „bardzo dobrą" znajomość
Excela od przeciętnej.

Zbuduj jedno zapytanie na tabelę `kontrahenci`, dodając kolejne kroki:
1. **Przytnij i wyczyść** (`Transform → Format → Trim / Clean`) kolumny tekstowe.
2. **Ujednolić wielkość liter** w nazwie (Capitalize Each Word) — ostrożnie z
   nazwami własnymi; alternatywnie zostaw oryginał i dodaj kolumnę znormalizowaną.
3. **Standaryzacja kraju:** kolumna warunkowa lub `Replace Values` mapująca
   `Polska/Poland/POL/pl → PL`.
4. **Normalizacja NIP:** `Replace Values` usuwające `-` i spacje → kolumna `nip_norm`.
5. **Standaryzacja kodu pocztowego** do formatu `NN-NNN`.
6. **Usuń duplikaty** po `nip_norm` (`Home → Remove Rows → Remove Duplicates`) —
   ale najpierw posortuj tak, by zostawał rekord „lepszy" (np. z uzupełnionym e-mailem).

Przykładowy krok w języku M (mapowanie kraju):
```m
= Table.ReplaceValue(
    #"Poprzedni krok",
    each [kraj],
    each if List.Contains({"Polska","Poland","POL","pl"}, [kraj]) then "PL" else [kraj],
    Replacer.ReplaceValue, {"kraj"})
```

**Kluczowa przewaga:** gdy dostaniesz nowy eksport z ERP, klikasz **Odśwież** i cały
proces czyszczenia wykonuje się od nowa. To jest „automatyzacja i standaryzacja
danych oraz procesów" z ogłoszenia.

**Deliverable:** skoroszyt Excela z zapytaniami Power Query dającymi „czyste"
tabele oraz porównanie liczby rekordów przed/po.

---

## Etap 5 — Python tam, gdzie jest najlepszy

**Cel:** dwie rzeczy, które w SQL/Excelu są niewygodne, w Pythonie są proste.

1. **Pełna walidacja sumy kontrolnej NIP** — algorytm z wagami `[6,5,7,2,3,4,5,6,7]`.
   W SQL da się to napisać, ale nieczytelnie; w Pythonie to kilka linii.
2. **Duplikaty rozmyte** — „Kowalski Sp. z o.o." vs „KOWALSKI SP Z OO" to ten sam
   podmiot, ale porównanie 1:1 tego nie złapie. Normalizujemy nazwę (usuwamy formę
   prawną, interpunkcję, wielkość liter) i porównujemy.

**Co zrobić:** uruchom `python/walidacja_nip.py`. Powstanie `dane/kontrahenci_flagi.csv`
z kolumnami `nip_status` (poprawny/błędny/brak), `dup_nip`, `dup_nazwa` — gotowe do
wczytania w Power BI obok danych.

**Deliverable:** plik flag jakości + akapit uzasadniający, *dlaczego* akurat te
zadania trafiły do Pythona (dobór narzędzia to też kompetencja).

---

## Etap 6 — Dashboard w Power BI (finalny produkt)

**Cel:** przekuć analizę w narzędzie, które zrozumie kierownictwo i które pozwala
zejść do konkretnych rekordów.

Pełna instrukcja krok po kroku (model, miary DAX, układ, drill-through) jest
w `powerbi/instrukcje_dashboard.md`. W skrócie:
- 4 karty KPI + miernik ogólnego wskaźnika jakości na stronie przeglądu,
- wykres naruszeń wg reguły (dane ze scorecard),
- druga strona „do poprawy" z listą rekordów i drill-through z wykresu,
- fragmentatory po statusie i typie kontrahenta.

**Deliverable:** plik `.pbix` + eksport do PDF do portfolio.

---

## Etap 7 — Framework data governance

**Cel:** pokazać, że rozumiesz, iż jakość danych to **proces i ludzie**, nie tylko
zapytania. To wyróżnik na tle kandydatów czysto „analitycznych".

Opisz na 1–2 stronach:
- **Role:** *data owner* (właściciel domeny, np. kierownik sprzedaży dla
  kontrahentów), *data steward* (dba o jakość operacyjnie), *użytkownik*.
- **Proces obsługi incydentu jakości:** wykrycie → zgłoszenie → analiza przyczyny
  → korekta → prewencja (reguła u źródła) → weryfikacja.
- **Słownik/glosariusz** kluczowych pojęć i reguł (np. definicja „aktywnego
  kontrahenta", dozwolone słowniki walut i jednostek).
- **Prewencja u źródła:** lista rekomendacji do ERP — pola obowiązkowe, walidacja
  NIP przy zapisie, słowniki zamknięte dla kraju/waluty/jednostki, blokada
  duplikatu NIP.

**Deliverable:** dokument „Zasady zarządzania danymi podstawowymi" — to wprost
„definiowanie ról, odpowiedzialności i procesów" z ogłoszenia.

---

## Etap 8 — Dokumentacja i prezentacja

**Cel:** opakować wszystko tak, by dało się to pokazać w 5 minut.

- **Podsumowanie „przed/po":** ile naruszeń wykryto, ile dałoby się usunąć procesem
  czyszczenia, ile wymaga zmian w ERP.
- **Prezentacja (5–8 slajdów):** problem → podejście → architektura → wyniki
  (dashboard) → rekomendacje prewencyjne.
- **README** do repozytorium (GitHub) z opisem i zrzutami ekranu.

**Deliverable:** repozytorium/portfolio gotowe do pokazania rekruterowi.

---

## Co wyeksponować w CV i rozmowie

- **Governance i jakość** (reguły, wymiary jakości, audyt, KPI, korekta vs.
  prewencja) — to rdzeń tej roli, którego większość kandydatów nie pokazuje.
- **SQL** do walidacji: JOIN-y, agregacje, wykrywanie duplikatów i rekordów
  osieroconych, funkcje okna.
- **Excel/Power Query** jako powtarzalny proces czyszczenia, nie ręczne poprawki.
- **Power BI** jako scorecard jakości z drill-through.
- **Świadomość biznesowa:** że jakość danych ma skutki finansowe i procesowe, oraz
  że naprawia się ją u źródła. Ogłoszenie kładzie na to wyraźny nacisk.
- Jeśli miałeś styczność z **Comarch ERP XL** lub **Dynamics 365** — wymień z nazwy.

## Kolejność pracy w skrócie
1. Środowisko + import (`01_tabele.sql`)
2. Profilowanie (`03_profilowanie.sql`) → raport „przed"
3. Rejestr reguł i KPI
4. Audyt SQL (`04_reguly_jakosci.sql`) → scorecard
5. Czyszczenie w Power Query → tabele „czyste"
6. Python: flagi NIP i duplikatów (`walidacja_nip.py`)
7. Dashboard Power BI (`powerbi/instrukcje_dashboard.md`)
8. Framework governance + prezentacja
