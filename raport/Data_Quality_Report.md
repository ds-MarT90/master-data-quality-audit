# Raport jakości danych
 
 **Kompletność tabeli**

*Tabela kontrahenci* - Rule ID: DQ-COMP-001 

Dane kontrahentów są niemal kompletne.
Jedyną kolumną zawierającą braki jest NIP.
Brakuje go w 80 na 2120 rekordów (3,77%).

*Tabela produkty* - Rule ID: DQ-COMP-002 

Dane kompletne.

*Tabela umowy* - Rule ID: DQ-COMP-003 

Dane kompletne.

*Tabela crm_kontakty* - Rule ID: DQ-COMP-004 

Dane kompletne.

*Tabela srodki_trwale* - Rule ID: DQ-COMP-005 

W kolumnie `numer_inwentarzowy` wykryto brak 18 na 600 rekordów (3% danych)
oraz w kolumnie `staka_amortyzacji` wykryto brak 30 na 600 rekordów (5% danych)


**Unikalność rekordów**

*Tabela kontrahenci* 

Rule ID: DQ-UNIQ-001

W kolumnie `nip` wykryto 120 duplikatów co stanowi 5,66% danych

Rule ID: DQ-UNIQ-002 

W kolumnie `regon`wykryto 120 duplikatów co stanowi 5,66% danych

*Tabela produkty* 

Rule ID: DQ-UNIQ-003 

 W kolumnie `indeks` wykryto wartości przypisane do więcej niż jednego produktu. Największa liczba wystąpień dotyczy indeksu PRD-50000, który został przypisany do 48 różnych rekordów(47 duplikatów).
 *Na potrzeby projektu przyjęto że indeks powinien być unikatowy, jednak w sytuacji real-world należałoby potwierdzić to z właścicielem danych*
 Dodatkowo wykryto 8 indeksów do których są przypisane po dwa różne produkty czyli kolejnych 8 zduplikowanych indeksów, łącznie 55 co stanowi 4,58% danych.

Rule ID: DQ-UNIQ-004 

W kolumnie `ean` nie wykryto duplikatów.

*Tabela umowy*

Rule ID: DQ-UNIQ-005 

W kolumnie `numer_umowy` wykryto 69 duplikatów (1,97% danych). Ten sam numer umowy został przypisany do wielu rekordów, w tym do różnych kontrahentów, co może wskazywać na naruszenie zasady unikalności numerów umów.

*Tabela crm_kontakty*

Rule ID: DQ-UNIQ-006

W tabeli crm_kontakty wykryto 3 przypadki(0,1% danych) zduplikowanych kombinacji `kontrahent_id` i `email`. Oznacza to, że ten sam adres e-mail został przypisany wielokrotnie do tego samego kontrahenta, co może wskazywać na zduplikowane rekordy w kontaktach.

*Tabela srodki_trwale*

Rule ID: DQ-UNIQ-007

W kolumnie `numer_inwentarzowy` nie wykryto duplikatów.


**Poprawność danych**

*Tabela kontrahenci*

Rule ID: DQ-VALID-001

W kolumnie `nip` wykryto 169 wartości w nieprawidłowym formacie (7,97% danych).

Rule ID: DQ-VALID-002

W kolumnie `regon` nie wykryto niepoprawnych wartości.

Rule ID: DQ-VALID-003

W kolumnie `kod_pocztowy` wykryto 104 wartości w nieprawidłowym formacie (4,91% danych).

Rule ID: DQ-VALID-004

W kolumnie `email` wykryto 59 wartości w nieprawidłowym formacie (2,78% danych).

Rule ID: DQ-VALID-005

W kolumnie `telefon` nie wykryto niepoprawnych wartości.

Rule ID: DQ-VALID-006

W kolumnie `typ` nie wykryto niepoprawnych wartości.

Rule ID: DQ-VALID-007

W kolumnie `status` nie wykryto niepoprawnych wartości.

*Tabela produkty*

Rule ID: DQ-VALID-008

W kolumnie `kategoria` nie wykryto niepoprawnych wartości.

Rule ID: DQ-VALID-009

W kolumnie `cena_zakupu` wykryto 9 błędnych, ujemnych wartości (0,75% danych).

Rule ID: DQ-VALID-010

W kolumnie `cena_sprzedazy` nie wykryto niepoprawnych wartości.

Rule ID: DQ-VALID-011

W kolumnie `ean` wykryto 48 wartości w nieprawidłowym formacie (4% danych).

Rule ID: DQ-VALID-012

W kolumnie `status` nie wykryto niepoprawnych wartości.

Rule ID: DQ-VALID-013

W wyniku analizy zidentyfikowano 36 produktów, dla których cena sprzedaży była niższa lub równa cenie zakupu. Stanowi to 3,00% wszystkich rekordów w tabeli produkty. Ujemny stosunek ceny zakupu do ceny sprzedaży świadczyć może o błędach przy wprowadzeniu danych, faktycznej nieświadomej sprzedaży z ujemną marżą lub celeowym działaniu wyprzedażowym. Wykryte przypadki wymagają dalszej analizy kontekstu biznesowego przed uznaniem ich za błędy.


**Spójność danych**

*Tabela kontrahenci*

Rule ID: DQ-CONS-001

W kolumnie `kraj` wykryto cztery różne sposoby przedstawiania tej samej wartości. 
Za wartość referencyjną przyjęto 'PL', ponieważ występuje najczęściej i jest zgodna z obowiązującym standardem. Wykryto 126 rekordów wymagających ustandaryzowania(5,94% danych).

Rule ID: DQ-CONS-002

W kolumnie `status` nie wykryto niespójności.

Rule ID: DQ-CONS-003

W kolumnie `typ` nie wykryto niespójności.

*Tabela produkty*

Rule ID: DQ-CONS-004

W kolumnie `kategoria` nie wykryto niespójności.

Rule ID: DQ-CONS-005

W kolumnie `jednostka_miary` wykryto sześć różnych wartości. Analiza wykazała, że wartości pcs, szt. oraz sztuka stanowią różne sposoby zapisu tej samej jednostki miary. Dodatkowo zidentyfikowano wartości opak i kpl. Choć są one poprawnymi jednostkami miary w określonych zastosowaniach, w analizowanym zbiorze zostały przypisane do usług, dla których nie stanowią właściwej jednostki. Na podstawie analizy kontekstu biznesowego również uznano je za wartości wymagające standaryzacji. Za wartość referencyjną przyjęto szt, ponieważ występuje w zdecydowanej większości rekordów i jest zgodna z przyjętym standardem. Łącznie zidentyfikowano 152 rekordy wymagające standaryzacji, co stanowi 12,67% wszystkich rekordów.

Rule ID: DQ-CONS-006

W kolumnie `stawka_vat` wykryto cztery różne sposoby przedstawiania tej samej wartości. 
Za wartość referencyjną przyjęto '23', ponieważ występuje w zdecydowanej większości i jest zgodna z obowiązującym standardem. Wykryto 120 rekordów wymagających ustandaryzowania(10% danych).
*Dane widocznie przedstawiają produkty obciążone 23% stawką VAT. W rzeczywistości reguła powinna się także odnosić do stawek 0%, 5% i 8% oraz ewentualnie uwzględnić 'ZW' czyli zwolnienie z podatku*

*Tabela umowy*

Rule ID: DQ-CONS-007

W kolumnie `waluta` wykryto dwa różne sposoby przedstawiania tej samej wartości oraz dodatkowo spacje wstawione za wartością - 'PLN '. 
Jako wartość referencyjną przyjęto 'PLN', ponieważ występuje najczęściej i jest zgodna z obowiązującym standardem zapisu kodów walut (ISO 4217). Wykryto 179 rekordów wymagających ustandaryzowania(5,11% danych).


**Aktualność danych**

*Tabela kontrahenci*

Rule ID: DQ-TIME-001

Nie wykryto rekordów, dla których data utworzenia byłaby późniejsza od bieżącej daty. Wszystkie analizowane daty spełniają przyjętą regułę aktualności.

*Tabela produkty*

Rule ID: DQ-TIME-002

Nie wykryto rekordów, dla których data utworzenia byłaby późniejsza od bieżącej daty. Wszystkie analizowane daty spełniają przyjętą regułę aktualności.

*Tabela umowy*

Rule ID: DQ-TIME-003

Nie wykryto rekordów, dla których data podpisania byłaby późniejsza od daty rozpoczęcia. Wszystkie analizowane daty spełniają przyjętą regułę aktualności.

Rule ID: DQ-TIME-004

Wykryto 103 przypadki dla których data rozpoczęcia jest późniejsza od daty zakończenia. Nieprawidłowe rekordy stanowią 2,94% danych.

Rule ID: DQ-TIME-005

Nie wykryto rekordów, dla których data podpisania byłaby późniejsza od bieżącej daty. Wszystkie analizowane daty spełniają przyjętą regułę aktualności.


**Integralność referencyjna**

*Tabela umowy*

Rule ID: DQ-REF-001  

W wyniku analizy zidentyfikowano 105 rekordów osieroconych, co stanowi 3,00% wszystkich rekordów w tabeli umowy. Oznacza to, że część umów zawiera identyfikatory kontrahentów, które nie istnieją w tabeli kontrahenci.

*Tabela crm_kontakty*

Rule ID: DQ-REF-002

W tabeli crm_kontakty wykryto 94 rekordy osierocone (3,04% danych). Oznacza to, że część kontaktów została przypisana do identyfikatorów kontrahentów, które nie istnieją w tabeli kontrahenci. Narusza to integralność referencyjną danych i może prowadzić do błędów podczas analiz oraz utrudniać prawidłowe powiązanie kontaktów z klientami.

*Tabela srodki_trwale*

Rule ID: DQ-REF-003

W bazie danych zidentyfikowano 24 środki trwałe (0,78 %danych), które odwołują się do nieistniejących kontrahentów. Takie rekordy mogą powodować problemy podczas analiz, raportowania oraz łączenia danych z tabelą kontrahentów. Zaleca się zweryfikowanie poprawności wartości dostawca_id oraz uzupełnienie brakujących rekordów w tabeli kontrahenci lub korektę błędnych odwołań.

## Podsumowanie

W ramach projektu przeprowadzono kompleksowy audyt jakości danych obejmujący osiem obszarów kontroli: profilowanie danych, kompletność, unikalność, poprawność, spójność, aktualność, walidację między polami oraz integralność referencyjną. Analiza pozwoliła zidentyfikować m.in. braki danych, duplikaty, błędy formatów, niespójne wartości słownikowe, nieprawidłowe zależności czasowe, naruszenia reguł biznesowych oraz rekordy osierocone. Dla każdego obszaru określono liczbę wykrytych nieprawidłowości, ich udział procentowy oraz przygotowano rekomendacje dotyczące dalszych działań.