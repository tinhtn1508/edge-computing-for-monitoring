package types

type Contact struct {
	Name  string `json:"name"`
	ID    int    `json:"id"`
	Phone string `json:"phone"`
	Email string `json:"email"`
}

type GetContactRequest struct {
	EdgeNode string `json:"edgenode"`
	Sensor   string `json:"sensor"`
}

type GetContactResponse []Contact
