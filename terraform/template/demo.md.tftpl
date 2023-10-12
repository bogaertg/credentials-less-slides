# Term 1

On GKE Cluster
```bash
helm repo add hashicorp https://helm.releases.hashicorp.com
helm repo update
helm install vault hashicorp/vault -n vault --create-namespace --values vault.yaml
helm install vault-secrets-operator hashicorp/vault-secrets-operator --version 0.3.1 -n vault-secrets-operator-system --create-namespace
```

# Term 2

```bash
kubectl exec --stdin=true --tty=true vault-0 -n vault -- /bin/sh

#export VAULT_ADDR="http://localhost:8200"
#vault operator init
#export VAULT_TOKEN=...
# ---> UNSEAL VAULT
vault secrets enable database

vault write database/config/my-postgresql-database \
    plugin_name="postgresql-database-plugin" \
    allowed_roles="my-role,my-static-role" \
    connection_url="postgresql://{{username}}:{{password}}@${CLOUD_SQL_IP}:5432/my-database" \
    username="postgres" \
    password="password" \
    password_authentication="scram-sha-256" \
    max_connection="1" \
    max_connection_lifetime="5s"


vault write database/roles/my-role \
    db_name=my-postgresql-database \
    creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
    GRANT cloudsqlsuperuser to \"{{name}}\";" \
    default_ttl="1m"  \
    max_ttl="1m"

vault write database/static-roles/my-static-role \
   db_name=my-postgresql-database \
   rotation_statements="ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';" \
   username=my-app \
   rotation_period="15s"


vault auth enable -path demo-auth-mount kubernetes

vault write auth/demo-auth-mount/config \
      kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443"

vault write sys/policy/gke policy="path \"*\" { capabilities = [\"create\", \"read\", \"update\", \"delete\", \"list\"] }"

vault write auth/demo-auth-mount/role/auth-role \
   bound_service_account_names=default \
   bound_service_account_namespaces=demo \
   token_ttl=0 \
   token_period=120 \
   token_policies=gke \
   audience=vault
```

Demo

```bash
vault read  database/config/my-postgresql-database
vault read database/roles/my-role
vault read database/creds/my-role
```




