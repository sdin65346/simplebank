CREATE TABLE abc.users (
  username varchar(255),
  hashed_password varchar(255) NOT NULL,
  full_name varchar(255) NOT NULL,
  email varchar(255) UNIQUE NOT NULL,
  password_changed_at date DEFAULT TO_DATE('01.01.2024', 'dd.mm.yyyy') NOT NULL,
  created_at date DEFAULT sysdate NOT NULL,
  CONSTRAINT username_pk PRIMARY KEY (username)
);

ALTER TABLE abc.accounts
  ADD CONSTRAINT owner_users_fk FOREIGN KEY (owner)
     REFERENCES abc.users (username) ON DELETE CASCADE;

-- CREATE UNIQUE INDEX ON abc.accounts (owner, currency);
ALTER TABLE abc.accounts 
  ADD CONSTRAINT owner_currency_fk UNIQUE (owner, currency);
