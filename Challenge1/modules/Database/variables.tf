variable "database_type" {
    type = string
    description = "can be mysql, MariaDB, PostgreSQL, MSSQL. Oracle"
}

variable "rbdinstance_name" {
    type = string
}

variable "engine_version" {
    type = string
    description = "default version form mysql 5.7"
}
 
variable "storagesize" {
    type = number
    default = 30
}

variable "instancetype" {
    type = string
}

variable "private_cidr" {
    type = list(string)
}