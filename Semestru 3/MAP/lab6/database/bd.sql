CREATE TABLE Utilizatori (
    id SERIAL PRIMARY KEY,
    nume VARCHAR(100),
    prenume VARCHAR(100),
    email VARCHAR(100),
    password VARCHAR(100)
);


CREATE TABLE Prietenii (
    id SERIAL PRIMARY KEY,
    id_user1 BIGINT NOT NULL,
    id_user2 BIGINT NOT NULL,
    friends_from TIMESTAMP NOT NULL,
    CONSTRAINT fk_user1 FOREIGN KEY (id_user1) REFERENCES Utilizatori (id) ON DELETE CASCADE,
    CONSTRAINT fk_user2 FOREIGN KEY (id_user2) REFERENCES Utilizatori (id) ON DELETE CASCADE,
    CONSTRAINT unique_friendship UNIQUE (id_user1, id_user2),
    CONSTRAINT no_self_friendship CHECK (id_user1 <> id_user2)
);
