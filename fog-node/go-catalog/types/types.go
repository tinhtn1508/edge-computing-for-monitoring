package types

type Contact struct {
	ID             int    `json:"id"`
	Name           string `json:"name"`
	Phone          string `json:"phone"`
	Email          string `json:"email"`
	GroupName      string `json:"groupname"`
	FactoryAddress string `json:"factory_address"`
}

type GetContactRequest struct {
	EdgeNode string `json:"edgenode"`
	Sensor   string `json:"sensor"`
}

type GetContactResponse []Contact
