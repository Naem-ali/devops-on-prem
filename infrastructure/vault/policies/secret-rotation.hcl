path "secret/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

path "auth/token/create" {
  capabilities = ["create", "read", "update"]
}

path "sys/leases/revoke-prefix/*" {
  capabilities = ["update"]
}

path "sys/leases/lookup/*" {
  capabilities = ["update"]
}
