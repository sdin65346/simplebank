DB_URL=oracle://abc:secret@0.0.0.0:1521/ORCLCDB
postgres:
	docker run \
		--name postgres16 \
		-p 5432:5432 \
		-e POSTGRES_USER=root \
		-e POSTGRES_PASSWORD=secret \
		-d postgres:16-alpine

oracle:
	docker run \
		--name oracledb \
		-p 1521:1521 \
		-e ORACLE_PDB=QUAD \
		-e ORACLE_PWD=secret \
		-e TZ=Europe/Moscow \
		-v oracledata:/opt/oracle/oradata \
		-v /etc/timezone:/etc/timezone:ro \
		-v /etc/localtime:/etc/localtime:ro \
		-d oracledb:1.0

createdb:
	docker exec -it postgres16 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres16 dropdb simple_bank

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratdown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/sdin65346/simplebank/db/sqlc Store

proto:
	rm -f pb/*.go
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	proto/*.proto

.PHONY: postgres createdb dropdb migrateup migrateup1 migratedown migratdown1 sqlc oracle test server mock proto
