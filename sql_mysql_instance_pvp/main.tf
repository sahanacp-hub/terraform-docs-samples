# [START cloud_sql_mysql_instance_pvp]
resource "google_sql_database_instance" "mysql_pvp_instance_name" {
  name             = "mysql-pvp-instance-name"
  region           = "asia-northeast1"
  database_version = "MYSQL_8_0"
  root_password = "abcABC123!"
  settings {
    tier              = "db-f1-micro"
    password_validation_policy {
      min_length  = 6
      complexity  =  "COMPLEXITY_DEFAULT"
      reuse_interval = 2
      disallow_username_substring = true
      enable_password_policy = true
    }
  }
  deletion_protection = false # set to true to prevent destruction of the resource
}
# [END cloud_sql_mysql_instance_pvp]
