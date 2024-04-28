CREATE TABLE abc.sessions (
    id varchar(255) PRIMARY KEY,
    username varchar(255) NOT NULL,
    refresh_token varchar(512) NOT NULL,
    user_agent varchar(255) NOT NULL,
    client_ip varchar(255) NOT NULL,
    is_blocked NUMBER DEFAULT 0 NOT NULL,
    expires_at date NOT NULL,
    created_at date DEFAULT sysdate NOT NULL
);

ALTER TABLE abc.sessions
    ADD CONSTRAINT username_fk FOREIGN KEY (username)
        REFERENCES abc.users (username) ON DELETE CASCADE;
