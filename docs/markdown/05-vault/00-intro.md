<!-- .slide: class="transition-bg-green-4" -->
# Vault

Notes: @Gaetan

##==##

<!-- .slides -->

## Vault

* Hashicorp product (OSS & Enterprise)
* Secret management tool
  
> A secret is anything that you want to tightly control access to,

<!-- .element: class="list-fragment" -->

<br/><br/>

<blockquote>
<cite style="color:red">
How to handle login to Vault ?
</cite>
</blockquote>
<!-- .element: class="fragment" -->

Notes: @Gaetan

##==##

<!-- .slides -->

## Auth method

![center h-800](./assets/images/auth_method.jpg)

Notes: @Gaetan

##==##

<!-- .slides -->

## Secret engines

* Google Cloud / AWS / Azure
* MongoDB atlas
* PKI
* SSH
* Transit (encryption as a service)
* Key-Value 🔥
* Databases 🔥
* ...
<!-- .element: class="list-fragment" -->

Notes: @Gaetan

##==##

<!-- .slides -->

## Key Value

![center h-800](./assets/images/kv.png)

Notes: @Gaetan

##==##

<!-- .slides -->

## Database engine

![center h-800](./assets/images/vault_database_engine.jpg)

Notes: @Gaetan

##==##

<!-- .slide: class="with-code" -->

## How to

```bash
vault secrets enable database

vault write database/config/my-db \
     plugin_name=postgresql-database-plugin \
     connection_url="postgresql://{{username}}:{{password}}@$POSTGRES_URL/postgres?sslmode=disable" \
     allowed_roles=admin \
     username="root" \
     password="rootpassword" #Root credential rotation
```
<!-- .element: class="big-code" -->

Notes: @Gaetan

##==##

<!-- .slide: class="with-code" -->

## Credentials

* Create user and password*
* Ephemeral 
* On demand

<br/><br/>

```bash
vault write database/roles/my-role \
db_name=my-db \
creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' \ 
VALID UNTIL '{{expiration}}'; GRANT cloudsqlsuperuser to \"{{name}}\";" \
default_ttl="1h"  \
max_ttl="1h"
```
<!-- .element: class="big-code" -->

##==##
<!-- .slide: class="with-code" -->

## How to

```bash
$ vault read database/creds/my-role

Key                Value
---                -----
lease_id           database/creds/my-role/2f6a614c-4aa2-7b19-24b9-ad944a8d4de6
lease_duration     1h
lease_renewable    true
password           SsnoaA-8Tv4t34f41baD
username           v-vaultuse-my-role-x
```
<!-- .element: class="big-code" -->

Notes: @Gaetan

##==##

<!-- .slide: class="with-code" -->

## Static Credentials

* 1-to-1 mapping to a user
* rotation based on schedule or period
* Get current password*
* Possible to force rotation

<br/><br/>


```bash
vault write database/static-roles/my-static-role \
   db_name=my-db \
   rotation_statements="ALTER USER \"{{name}}\" WITH PASSWORD '{{password}}';" \
   username=my-app \
   rotation_period="15s"
```
<!-- .element: class="big-code" -->


Notes: @Gaetan

##==##
<!-- .slide: class="with-code" -->

## How to

```bash
$ vault read database/static-creds/my-static-role
Key                    Value
---                    -----
last_vault_rotation    2023-10-11T15:10:13.257934557Z
password               A-d3ZKJLdyeyEgnAmNH9
rotation_period        15s
ttl                    3s
username               my-app

```
<!-- .element: class="big-code" -->

Notes: @Gaetan
