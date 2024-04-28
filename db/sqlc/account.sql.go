package db

import (
	"context"
	_ "github.com/sijms/go-ora/v2"
)

type AddAccountBalanceParams struct {
	Amount int64 `json:"amount"`
	ID     int64 `json:"id"`
}

const addAccountBalance = `-- name: AddAccountBalance :one
UPDATE accounts
SET balance = balance + :1
WHERE id = :2
--RETURNING owner, balance, currency, created_at INTO :3, :4, :5, :6
`

func (q *Queries) AddAccountBalance(ctx context.Context, arg AddAccountBalanceParams) (Account, error) {
	var i Account

	i.ID = arg.ID
	i.Balance = i.Balance + arg.Amount

	_, err := q.db.ExecContext(ctx,
		addAccountBalance,
		arg.Amount,
		arg.ID,
		//&i.Owner,
		//&i.Balance,
		//&i.Currency,
		//&i.CreatedAt
	)

	row := q.db.QueryRowContext(ctx, getAccount, arg.ID)
	err = row.Scan(
		&i.ID,
		&i.Owner,
		&i.Balance,
		&i.Currency,
		&i.CreatedAt,
	)

	return i, err
}

type CreateAccountParams struct {
	Owner    string `json:"owner"`
	Balance  int64  `json:"balance"`
	Currency string `json:"currency"`
}

const createAccount = `-- name: CreateAccount :one
	INSERT INTO abc.accounts (owner, balance, currency) 
	VALUES (:1, :2, :3) 
	RETURNING id, created_at INTO :4, :5
`

func (q *Queries) CreateAccount(ctx context.Context, arg CreateAccountParams) (Account, error) {
	var i Account

	i.Owner = arg.Owner
	i.Balance = arg.Balance
	i.Currency = arg.Currency

	_, err := q.db.ExecContext(ctx,
		createAccount,
		arg.Owner,
		arg.Balance,
		arg.Currency,
		&i.ID,
		&i.CreatedAt)

	return i, err
}

const deleteAccount = `-- name: DeleteAccount :exec
	DELETE FROM abc.accounts
	WHERE id = :1
`

func (q *Queries) DeleteAccount(ctx context.Context, id int64) error {
	_, err := q.db.ExecContext(ctx, deleteAccount, id)
	return err
}

const getAccount = `-- name: GetAccount :one
	SELECT id, owner, balance, currency, created_at 
	FROM abc.accounts
	WHERE id = :1 
	FETCH FIRST 1 ROW ONLY
`

func (q *Queries) GetAccount(ctx context.Context, id int64) (Account, error) {
	var i Account

	row := q.db.QueryRowContext(ctx, getAccount, id)
	err := row.Scan(
		&i.ID,
		&i.Owner,
		&i.Balance,
		&i.Currency,
		&i.CreatedAt,
	)
	return i, err
}

const getAccountForUpdate = `-- name: GetAccountForUpdate :one
	SELECT id, owner, balance, currency, created_at 
	FROM abc.accounts
	WHERE id = :1 
	FETCH FIRST 1 ROW ONLY
	FOR UPDATE owner, balance, currency, created_at
`

func (q *Queries) GetAccountForUpdate(ctx context.Context, id int64) (Account, error) {
	var i Account

	row := q.db.QueryRowContext(ctx, getAccountForUpdate, id)
	err := row.Scan(
		&i.ID,
		&i.Owner,
		&i.Balance,
		&i.Currency,
		&i.CreatedAt,
	)
	return i, err
}

type ListAccountsParams struct {
	Owner  string `json:"owner"`
	Limit  int32  `json:"limit"`
	Offset int32  `json:"offset"`
}

const listAccounts = `-- name: ListAccounts :many
	SELECT id, owner, balance, currency, created_at 
	FROM abc.accounts
	WHERE owner = :1
	ORDER BY id
	OFFSET :2 ROWS FETCH NEXT :3 ROWS ONLY
`

func (q *Queries) ListAccounts(ctx context.Context, arg ListAccountsParams) ([]Account, error) {
	rows, err := q.db.QueryContext(ctx, listAccounts, arg.Owner, arg.Offset, arg.Limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	items := []Account{}
	for rows.Next() {
		var i Account
		if err := rows.Scan(
			&i.ID,
			&i.Owner,
			&i.Balance,
			&i.Currency,
			&i.CreatedAt,
		); err != nil {
			return nil, err
		}
		items = append(items, i)
	}
	if err := rows.Close(); err != nil {
		return nil, err
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}

type UpdateAccountParams struct {
	ID      int64 `json:"id"`
	Balance int64 `json:"balance"`
}

const updateAccount = `-- name: UpdateAccount :one
	UPDATE abc.accounts
	SET balance = :1 
	WHERE id = :2
	--RETURNING owner, currency, created_at INTO :3, :4, :5 
`

func (q *Queries) UpdateAccount(ctx context.Context, arg UpdateAccountParams) (Account, error) {
	var i Account

	i.ID = arg.ID
	i.Balance = arg.Balance

	_, err := q.db.ExecContext(ctx,
		updateAccount,
		arg.Balance,
		arg.ID,
		//&i.Owner,
		//&i.Currency,
		//&i.CreatedAt
	)

	row := q.db.QueryRowContext(ctx, getAccount, arg.ID)
	err = row.Scan(
		&i.ID,
		&i.Owner,
		&i.Balance,
		&i.Currency,
		&i.CreatedAt,
	)

	return i, err
}
