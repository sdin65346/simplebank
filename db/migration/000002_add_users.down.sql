ALTER TABLE abc.accounts DROP CONSTRAINT owner_currency_fk;

ALTER TABLE abc.accounts DROP CONSTRAINT owner_users_fk;

DROP TABLE abc.users;
