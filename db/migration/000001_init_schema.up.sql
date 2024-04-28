CREATE SEQUENCE abc.accounts_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 9999999999999999999999999999
  NOCYCLE
  ORDER
  NOCACHE
  NOKEEP
  GLOBAL;

CREATE TABLE abc.accounts (
    id number PRIMARY KEY,
    owner varchar2(255) NOT NULL,
    balance number NOT NULL,
    currency varchar2(255) NOT NULL,
    created_at date DEFAULT sysdate NOT NULL
);

CREATE OR REPLACE TRIGGER abc.accounts_bi
BEFORE INSERT ON abc.accounts
FOR EACH ROW
BEGIN
  SELECT accounts_s.NEXTVAL INTO :NEW.id FROM dual;
END;


CREATE SEQUENCE abc.entries_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 9999999999999999999999999999
  NOCYCLE
  ORDER
  NOCACHE
  NOKEEP
  GLOBAL;

CREATE TABLE abc.entries (
    id number PRIMARY KEY,
    account_id number NOT NULL,
    amount number NOT NULL,
    created_at date DEFAULT sysdate NOT NULL
);

CREATE OR REPLACE TRIGGER abc.entries_bi
BEFORE INSERT ON abc.entries
FOR EACH ROW
BEGIN
  SELECT entries_s.NEXTVAL INTO :NEW.id FROM dual;
END;

CREATE SEQUENCE abc.transfers_s
  INCREMENT BY 1
  START WITH 1
  MINVALUE 1
  MAXVALUE 9999999999999999999999999999
  NOCYCLE
  ORDER
  NOCACHE
  NOKEEP
  GLOBAL;

CREATE TABLE abc.transfers (
    id number PRIMARY KEY,
    from_account_id number NOT NULL,
    to_account_id number NOT NULL,
    amount number NOT NULL,
    created_at date DEFAULT sysdate NOT NULL
);

CREATE OR REPLACE TRIGGER abc.transfers_bi
BEFORE INSERT ON abc.transfers
FOR EACH ROW
BEGIN
  SELECT transfers_s.NEXTVAL INTO :NEW.id FROM dual;
END;    

ALTER TABLE abc.entries
    ADD CONSTRAINT account_id FOREIGN KEY (account_id)
        REFERENCES abc.accounts (id) ON DELETE CASCADE;

ALTER TABLE abc.transfers
    ADD CONSTRAINT from_account_id FOREIGN KEY (from_account_id)
        REFERENCES abc.accounts (id) ON DELETE CASCADE;

ALTER TABLE abc.transfers
    ADD CONSTRAINT to_account_id FOREIGN KEY (to_account_id)
        REFERENCES abc.accounts (id) ON DELETE CASCADE;

CREATE INDEX abc.accounts_i ON accounts(owner);

CREATE INDEX abc.entries_i ON entries(account_id);

CREATE INDEX abc.transfers_i ON transfers(from_account_id);

CREATE INDEX abc.transfers_i1 ON transfers(to_account_id);

CREATE INDEX abc.transfers_i3 ON transfers(from_account_id, to_account_id);

COMMENT ON COLUMN abc.entries.amount IS 'can be negative or positive';

COMMENT ON COLUMN abc.transfers.amount IS 'must be positive';
