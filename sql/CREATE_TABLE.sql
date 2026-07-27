CREATE TABLE dq_wyniki (
    Rule_ID varchar(20),
    Wymiar_jakości varchar(30),
    Nazwa_tabeli             varchar(30),
    Opis_reguły              varchar(200),
    Liczba_naruszeń          int,
    Liczba_rekordów          int,
    Procentowy_udział_błędów decimal(5,2)
);