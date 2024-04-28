package db

import (
	"log"
	"os"
	"testing"

	"database/sql"
	_ "github.com/lib/pq"
	"github.com/sdin65346/simplebank/util"
	_ "github.com/sijms/go-ora/v2"
)

var testQueries *Queries
var testDB *sql.DB

func TestMain(m *testing.M) {
	config, err := util.LoadConfig("../..")
	if err != nil {
		log.Fatal("cannot load config:", err)
	}

	testDB, err = sql.Open(config.DBDriver, config.DBSource)
	if err != nil {
		log.Fatal("cannot connect to db:", err)
	}

	testQueries = New(testDB)

	os.Exit(m.Run())
}
