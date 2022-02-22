package db

import (
	"context"
	"database/sql"
	"errors"
	"food-delivery/pkg/models"
	"github.com/bxcodec/faker/v3/support/slice"
	"log"
	"strconv"
	"time"
)

type UserRepo struct {
	*DB
	CachedSupplier map[int64]*struct {
		Supplier *models.Supplier
		DeadTime time.Time
	}
	CachedBranch map[int64]*struct {
		Branch   *models.Branch
		DeadTime time.Time
	}
	CachedClients map[int64]*struct {
		Client   *models.Client
		DeadTime time.Time
	}
}

var keys = []string{
	"login", "email", "id",
}
var userTypes map[string]int64
var globalUserRepo *UserRepo

func InitUserRepo(db *DB) (*UserRepo, error) {
	globalUserRepo = &UserRepo{
		DB: db,
		CachedSupplier: make(map[int64]*struct {
			Supplier *models.Supplier
			DeadTime time.Time
		}),
		CachedBranch: make(map[int64]*struct {
			Branch   *models.Branch
			DeadTime time.Time
		}),
		CachedClients: make(map[int64]*struct {
			Client   *models.Client
			DeadTime time.Time
		}),
	}
	userTypes = make(map[string]int64)

	newSupplierTypes, err := globalUserRepo.LoadTypes("supplier_types")
	if err != nil {
		return nil, err
	}
	supplierTypes := *models.GetSupplierTypes()
	for k, v := range newSupplierTypes {
		supplierTypes[k] = &v
	}

	return globalUserRepo, nil
}

func GetUserRepo() *UserRepo {
	return globalUserRepo
}

func (r *UserRepo) GetUserType(id int64) (userType string, err error) {
	query := "SELECT users_types.name FROM users JOIN users_types on users.user_type_id = users_types.id WHERE users.id = ?;"
	err = r.Conn.QueryRow(query, id).Scan(&userType)
	return
}

// TODO return type
func (r *UserRepo) LoadUser(key, value string) (int64, string, error) {
	if !slice.Contains(keys, key) {
		return 0, "", errors.New("key unknown")
	}
	query :=
		"SELECT users.id, users.name, users.login, users.email, ut.name FROM" +
			" users JOIN users_types ut on users.user_type_id = ut.id WHERE users." +
			key + " = ?"
	log.Println(query)
	row := r.Conn.QueryRow(query, value)
	var user models.User
	var userType string
	err := row.Scan(&user.ID, &user.Name, &user.Login, &user.Email, &userType)
	if err != nil {
		return 0, "", err
	}
	switch userType {
	case "Supplier":
		_, err = globalUserRepo.loadSupplier(user)
	case "Branch":
		_, err = globalUserRepo.loadBranch(user)
	case "Client":
		_, err = globalUserRepo.loadClient(user)
	default:
		err = errors.New("user type not found from db")
	}
	return user.ID, userType, err
}
func (r *UserRepo) SaveUser(user models.User, userType string, tx *sql.Tx, ctx context.Context) (int64, error) {
	if _, ok := userTypes[userType]; !ok {
		return 0, errors.New("user type unknown")
	}
	var saver Saver
	if user.ID == 0 {
		saver = Saver{
			Query: "INSERT INTO users(name, login, email, pass_hash, user_type_id) VALUE (?, ?, ?, ?, ?);",
			Args:  []interface{}{user.Name, user.Login, user.Email, user.PassHash, userTypes[userType]},
		}
	} else {
		saver = Saver{
			Query: "UPDATE users SET name = ?, login = ?, email = ?, pass_hash = ? WHERE id = ?;",
			Args:  []interface{}{user.Name, user.Login, user.Email, user.PassHash, user.ID},
		}
	}
	return saver.Save(tx, ctx)
}
func (r *UserRepo) LoadPassHash(userId int64) (passHash string, err error) {
	err = r.Conn.QueryRow("SELECT pass_hash FROM users WHERE id = ?;", userId).Scan(&passHash)
	return
}

// Client methods
func (r *UserRepo) GetClient(id int64) (*models.Client, error) {
	if data, ok := r.CachedClients[id]; !ok {
		_, _, err := r.LoadUser("id", strconv.FormatInt(id, 10))
		if err != nil {
			return nil, err
		}
		return r.GetClient(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Client, nil
	}
}
func (r *UserRepo) loadClient(user models.User) (models.Client, error) {
	row := r.Conn.QueryRow("SELECT phone FROM client_info WHERE user_id = ?", user.ID)
	if row.Err() != nil {
		return models.Client{}, row.Err()
	}
	client := models.Client{User: user}
	err := row.Scan(&client.Phone)
	if err != nil {
		return models.Client{}, err
	}
	_, err = globalHelperRepo.GetCoordinatesByClient(&client)
	if err != nil {
		return models.Client{}, err
	}
	r.AddClient(client)
	return client, nil
}
func (r *UserRepo) SaveClient(client *models.Client, tx *sql.Tx, ctx context.Context) (int64, error) {
	newId, err := r.SaveUser(client.User, "Client", tx, ctx)
	if err != nil {
		return 0, err
	}
	var (
		args  = []interface{}{client.Phone, newId}
		saver Saver
	)
	if client.ID == 0 {
		saver = Saver{
			Query: "INSERT INTO client_info(phone, user_id) VALUE (?, ?);",
			Args:  args,
		}
	} else {
		saver = Saver{
			Query: "UPDATE client_info SET phone = ? WHERE user_id = ?;",
			Args:  args,
		}
	}
	_, err = saver.Save(tx, ctx)
	if err != nil {
		return 0, err
	}
	return newId, err
}
func (r *UserRepo) AddClient(client models.Client) {
	r.CachedClients[client.ID] = &struct {
		Client   *models.Client
		DeadTime time.Time
	}{Client: &client, DeadTime: time.Now().Add(time.Hour)}
}

// Branch methods
func (r *UserRepo) GetBranch(id int64) (*models.Branch, error) {
	if data, ok := r.CachedBranch[id]; !ok {
		_, _, err := r.LoadUser("id", strconv.FormatInt(id, 10))
		if err != nil {
			return nil, err
		}
		return r.GetBranch(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Branch, nil
	}
}
func (r *UserRepo) loadBranch(user models.User) (models.Branch, error) {
	row := r.Conn.QueryRow("SELECT coordinate_id, image, open_time, close_time, supplier_id FROM supl_branches WHERE id = ?", user.ID)
	branch := models.Branch{
		User: user,
	}
	var (
		supplId, coordinatesId int64
	)
	err := row.Scan(&coordinatesId, &branch.Image, &branch.WorkingHour.Open, &branch.WorkingHour.Close, &supplId)
	if err != nil {
		return models.Branch{}, err
	}
	coordinate, err := globalHelperRepo.GetCoordinate(coordinatesId)
	if err != nil {
		log.Println(err, "when load branch from coordinate")
		return models.Branch{}, err
	}
	branch.Coordinate = *coordinate
	r.AddBranch(branch)
	// TODO вынести время жизни в конфигурацию
	return branch, nil
}
func (r *UserRepo) SaveBranch(branch *models.Branch, tx *sql.Tx, ctx context.Context) error {
	newId, err := r.SaveUser(branch.User, "Branch", tx, ctx)
	if err != nil {
		return err
	}
	if newId == 0 {
		newId = branch.ID
	}
	var (
		args = []interface{}{branch.Image, branch.WorkingHour.Open, branch.WorkingHour.Close, newId}
	)
	if branch.ID == 0 {
		_, err = Saver{
			Query: "INSERT INTO branches(image, open_time, close_time,user_id, supplier_id, coordinate_id) VALUE (?, ?, ?, ?, ?, ?);",
			Args:  append(args, branch.Supplier.ID, branch.Coordinate.ID),
		}.Save(tx, ctx)
	} else {
		_, err = Saver{
			Query: "UPDATE branches SET image = ?, open_time = ?, close_time = ? WHERE id = ?;",
			Args:  args,
		}.Save(tx, ctx)
	}
	if err != nil {
		return err
	}
	if branch.ID == 0 {
		branch.ID = newId
	}
	return nil
}
func (r *UserRepo) AddBranch(branch models.Branch) {
	r.CachedBranch[branch.ID] = &struct {
		Branch   *models.Branch
		DeadTime time.Time
	}{Branch: &branch, DeadTime: time.Now().Add(time.Hour)}
}

// Supplier methods
func (r *UserRepo) GetSupplier(id int64) (*models.Supplier, error) {
	if data, ok := r.CachedSupplier[id]; !ok {
		_, _, err := r.LoadUser("id", strconv.FormatInt(id, 10))
		if err != nil {
			return nil, err
		}
		return r.GetSupplier(id)
	} else {
		data.DeadTime = time.Now().Add(time.Hour)
		return data.Supplier, nil
	}
}
func (r *UserRepo) loadSupplier(user models.User) (models.Supplier, error) {
	row := r.Conn.QueryRow("SELECT supplier_info.description, supplier_info.supplier_type_id FROM supplier_info WHERE id = ?", user.ID)
	supplier := models.Supplier{User: user}
	var supplTypeId int64
	err := row.Scan(&supplier.Description, &supplTypeId)
	if err != nil {
		return models.Supplier{}, err
	}
	supplier.Type = (*models.GetSupplierTypes())[supplTypeId]
	r.AddSupplier(supplier)
	// TODO вынести время жизни в конфигурацию
	return supplier, nil
}
func (r *UserRepo) SaveSupplier(supplier *models.Supplier, tx *sql.Tx, ctx context.Context) error {
	newId, err := r.SaveUser(supplier.User, "Supplier", tx, ctx)
	if err != nil {
		return err
	}
	typeId := models.GetSupplierTypeId(supplier.Type)
	if typeId == 0 {
		return errors.New("supplier type unknown (is 0)")
	}
	var saver Saver
	if supplier.ID == 0 {
		saver = Saver{
			Query: "INSERT INTO supplier_info(description, supplier_type_id, image, user_id) VALUE (?, ?, ?, ?);",
		}
	} else {
		saver = Saver{
			Query: "UPDATE supplier_info SET description = ?, supplier_type_id = ?, image = ? WHERE user_id = ?;",
		}
	}
	supplier.ID = newId
	saver.Args = []interface{}{supplier.Description, typeId, supplier.Image, supplier.User.ID}
	_, err = saver.Save(tx, ctx)
	return err
}
func (r *UserRepo) AddSupplier(supplier models.Supplier) {
	r.CachedSupplier[supplier.ID] = &struct {
		Supplier *models.Supplier
		DeadTime time.Time
	}{Supplier: &supplier, DeadTime: time.Now().Add(time.Hour)}
}

func (r *UserRepo) GetSuppliersList() ([]models.Supplier, error) {
	query := "SELECT supplier_info.user_id, supplier_info.description, supplier_info.image, u.name, st.name FROM supplier_info\nJOIN users u on supplier_info.user_id = u.id\nJOIN supplier_types st on supplier_info.supplier_type_id = st.id;"
	rows, err := r.Conn.Query(query)
	if err != nil {
		return nil, err
	}
	suppliers := make([]models.Supplier, 0)
	for rows.Next() {
		var s models.Supplier
		err = rows.Scan(&s.ID, &s.Description, &s.Image, &s.Name, &s.Type)
		if err != nil {
			return nil, err
		}
		suppliers = append(suppliers, s)
	}
	return suppliers, nil
}
