DROP TABLE IF EXISTS users ;

-- Tablica użytkowników systemu
CREATE TABLE IF NOT EXISTS users (
	usr_id	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	usrnam	TEXT(32) NOT NULL UNIQUE,
	firnam	TEXT(32) NOT NULL,
	lasnam	TEXT(64) NOT NULL,
	passwd	TEXT(255) NOT NULL,
	is_del	INTEGER(1) NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS currencies ;

-- Słownik walut
CREATE TABLE IF NOT EXISTS currencies (
	cursmb	TEXT(3) NOT NULL PRIMARY KEY,
	curnam	TEXT(32) NOT NULL,
	dscrpt	TEXT(255) NULL,
	is_def	INTEGER(1) NOT NULL DEFAULT 0,
	is_del	INTEGER(1) NOT NULL DEFAULT 0
);

DROP TABLE IF EXISTS accounts ;

-- Słownik kont (w tym bankowych)
CREATE TABLE IF NOT EXISTS accounts (
	accoid	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, -- identyfikator konta 
	acname	TEXT(255) NOT NULL, -- nazwa konta
	acnumb	TEXT(64) NOT NULL UNIQUE, -- numer konta w formacie OBAN
	cursmb	TEXT(3) NOT NULL, -- waluta konta
	iscash	INTEGER(1) NOT NULL DEFAULT 0, -- Oznaczenie, czy jest to kasa (1), czy konto (0)
	baldat	TEXT(19) NULL,  -- Data stanu konta
	balval	NUMERIC(12,2) NOT NULL DEFAULT 0, -- Stan konta na dzień
	is_def	INTEGER(1) NOT NULL DEFAULT 0, -- Konto domyślne
	is_del	INTEGER(1) NOT NULL DEFAULT 0, -- Konto usunięte (1)
	CONSTRAINT ACCOUNTS_FK_CURSMB FOREIGN KEY (cursmb) REFERENCES currencies(cursmb)
);

DROP TABLE IF EXISTS currency_exchange ; 

-- Tablica kursów walut
CREATE TABLE IF NOT EXISTS currency_exchange (
	cex_id	INTEGER	NOT NULL PRIMARY KEY AUTOINCREMENT, -- Identyfikator kursu
	curfrm	TEXT(3)	NOT NULL REFERENCES currencies(cursmb), -- Waluta z której przeliczamy
	curto_	TEXT(3)	NOT NULL REFERENCES currencies(cursmb), -- Waluta, na którą przeliczamy
	exdate	TEXT(19)	NOT NULL, -- Data kursu
	selval	NUMERIC(12,6)	NOT NULL DEFAULT 0, -- Kurs sprzedaży
	buyval	NUMERIC(12,6)	NOT NULL DEFAULT 0, -- Kurs zakupu
	midval	NUMERIC(12,6)	NOT NULL DEFAULT 0 -- Kurs średni
);

-- Tabela słownikowa kategorii wydatków i przychodów
DROP TABLE IF EXISTS categories ;

CREATE TABLE IF NOT EXISTS categories(
	cat_id	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT, -- Klucz główny
	prn_id	INTEGER NULL	REFERENCES categories(cat_id), -- Kategoria nadrzędna
	catsmb	TEXT(32) NOT NULL 	UNIQUE, -- Symbol kategorii
	catnam	TEXT(255) NOT NULL -- Nazwa kategorii
);

-- Tabela słownikowa MPK
DROP TABLE IF EXISTS places ;

CREATE TABLE IF NOT EXISTS places(
	plc_id	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT, -- Klucz główny
	prn_id	INTEGER NULL	REFERENCES places(plc_id), -- identyfikator nadrzędnego MPK
	plcsmb	TEXT(32) NOT NULL 	UNIQUE, -- MPK
	plcnam	TEXT(255) NOT NULL -- Nazwa
);

-- Tabela słownikowa dodatkowej analityki
DROP TABLE IF EXISTS additional_analitycs ;

CREATE TABLE IF NOT EXISTS additional_analitycs(
	adanid	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT, -- Klucz główny
	prn_id	INTEGER NULL	REFERENCES additional_analitycs(adanid), -- Konto nadrzędne
	adasmb	TEXT(32) NOT NULL 	UNIQUE, -- symbol konta
	adanam	TEXT(255) NOT NULL -- nazwa konta
);

-- Tabela statusów
DROP TABLE IF EXISTS types_of_states ;

CREATE TABLE IF NOT EXISTS types_of_states(
	tpstid	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT,
	tpstnm	TEXT(255) NOT NULL, -- Nazwa statusu
	tpsttp	TEXT(32) NOT NULL, -- Typ statusu (INITIAL, TEMPORARY, FINAL, ACCEPTER, CANCEL)
	cltpnm 	TEXT(32) NOT NULL, -- Klasa statusu (od nazwy tabeli, której dotyczy) 
	prior_ 	INTEGER, -- Kolejność
	is_del	INTEGER(1) NOT NULL DEFAULT 0 -- Status usunięty (1)
);


-- Tabela ustawień
DROP TABLE IF EXISTS settings ;

CREATE TABLE IF NOT EXISTS settings(
	set_id	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT,
	setnam	TEXT(32) NOT NULL 	UNIQUE, -- Nazwa wartości
	setval	TEXT(255) NOT NULL -- Wartość
);

-- Tabela kontrahentów
DROP TABLE IF EXISTS contacts ;

CREATE TABLE IF NOT EXISTS contacts (
	contid	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT,
	name_1	TEXT(255) NOT NULL, -- Nazwa główna lub imię
	name_2 	TEXT(255) NULL, -- Nazwa dodatkowa lub nazwisko
	shrnam 	TEXT(32) NOT NULL UNIQUE,	-- Nazwa skrócona
	symbol	TEXT(255) NULL, -- Symbol kontrahenta
	ph_num 	TEXT(255) NULL, -- Numer telefonu stacjonarnego
	mobile	TEXT(255) NULL, -- Numer telefonu komórkowego
	e_mail	TEXT(255) NULL, -- Ades email
	comnts	TEXT(1024) NULL, -- Uwagi do klienta
	tpstid	INTEGER NULL REFERENCES types_of_states(tpstid), -- Status klienta
	is_del	INTEGER(1) NOT NULL DEFAULT 0 -- Konto klienta usunięte(1)
);

DROP TABLE IF EXISTS addresses ;

CREATE TABLE IF NOT EXISTS addresses(
	addrid	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT,
	contid	INTEGER	NOT NULL	REFERENCES contacts(contid),
	street	TEXT(255) 	NULL, -- Ulica
	bldnum	TEXT(32)	NULL, -- Numer budynku
	fltnum	TEXT(32)	NULL, -- Numer lokalu
	code__	TEXT(16)	NULL, -- Kod pocztowy
	city__	TEXT(255)	NULL, -- Miejscowość
	distct	TEXT(64)	NULL, -- Województwo
	countr	TEXT(32)	NULL, -- Kraj
	ismain	INTEGER(1)	NOT NULL DEFAULT 0, -- Czy adres domyślny (1)
	is_del	INTEGER(1)	NOT NULL DEFAULT 0-- Czy adres usunięty (1)	
);


-- tabela operacji kwotowych
DROP TABLE IF EXISTS operations ;

CREATE TABLE IF NOT EXISTS operations (
	opr_id	INTEGER	NOT NULL	PRIMARY KEY AUTOINCREMENT,
	oprtyp	TEXT(3)	NOT NULL, -- Typ operacji wykonywanej: INC (przychód), OUT (rozchód), INT (wewnętrna)  
	oprdat	TEXT(19)	NOT NULL,	 -- Data operacji
	cursmb	TEXT(3) NOT NULL REFERENCES currencies(cursmb), -- Waluta operacji
	amount	NUMERIC(12,2) NOT NULL DEFAULT 0, -- kwota operacji
	title_	TEXT(255) NOT NULL, -- Tytuł operacji
	dscrpt	BLOB	NULL, -- Opis operacji 
	cat_id	INTEGER	NOT NULL REFERENCES categories(cat_id),
	plc_id	INTEGER	NULL REFERENCES places(plc_id),
	adanid	INTEGER NULL REFERENCES additional_analitycs(adanid),
	contid	INTEGER NULL REFERENCES contacts(contid),
	addrid	INTEGER NULL REFERENCES addresses(addrid),
	f_cont	TEXT(255)	NOT NULL, -- Nazwa klienta z adresem
	adddat	TEXT(19)	NOT NULL, -- Data dodania wpisu
	adduid	INTEGER NOT NULL REFERENCES users(usr_id),
	tpstid	INTEGER NULL REFERENCES types_of_states(tpstid),
	is_del	INTEGER(1) NOT NULL DEFAULT 0 -- Znacznik, czy operacja jest usunięta (0)
-- 	CONSTRAINT operations_oprtyp_ck CHECK oprtyp IN ('INC','OUT','INT') 
);



