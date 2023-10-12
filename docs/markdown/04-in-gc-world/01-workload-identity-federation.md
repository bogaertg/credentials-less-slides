<!-- .slide: -->

## Workload identity federation

* GA since April 09, 2021
* allow to use external identities for accessing google services
  * IAM roles

![center h-500](./assets/images/workload_identity_federation_def.png)
<!-- .element: class="fragment" -->

Notes: @Gaetan

##==##
<!-- .slide: -->

## Workload identity federation

* Workload identity pool :
  * an entity that lets you manage external identities.

<br/><br/>

* Workload identity providers : a relationship between Google Cloud and your IdP
  * Github
  * AWS
  * Azure Active Directory
  * ...

Notes: @Gaetan

##==##
<!-- .slide: -->

## Workload identity provider

![center h-700](./assets/images/workload_identity_federation.png)

Notes: @Gaetan

##==##
<!-- .slide: -->

## Github x Google Cloud

![center h-600](./assets/images/workload_identity_github.jpg)

Notes: @Gaetan

##==##
<!-- .slide: class="with-code" -->

## How to

```bash
gcloud iam workload-identity-pools create "my-pool" \
  --project="gbo-conf-1" \
  --location="global" \
  --display-name="Demo pool"  
```
<!-- .element: class="big-code" -->

Notes: @Gaetan

##==##
<!-- .slide: class="with-code" -->

## How to

```bash[|3,|4-5|6]
gcloud iam workload-identity-pools providers create-oidc "github" \
  --workload-identity-pool="my-pool" \
  --attribute_condition = "assertion.repository_owner == \"bogaertg\""
  --attribute-mapping="google.subject=assertion.sub,
                       attribute.repository=assertion.repository" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```
<!-- .element: class="big-code" -->

Notes: @Gaetan

JSON Web Key Set (JWKS) clés publiques validation JWT
.well-known/openid-configuration


##==##
<!-- .slide: class="with-code" -->

## How to

```bash[|4]
gcloud iam service-accounts add-iam-policy-binding "gar-pusher@gbo-conf-1.iam.gserviceaccount.com" \
  --project="gbo-conf-1" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.../${WK_PROVIDER_NAME}/attribute.repository/bogaertg/my-app"
```

<!-- .element: class="big-code" -->

Notes: @Gaetan

workloadIdentityUser : emprunter l'identité d'un SA

##==##
<!-- .slide: class="with-code" -->

## How to

### Github Actions

```yaml[|4-5|7-12|14-20]
jobs:
  build:
    permissions:
      contents: 'read'
      id-token: 'write'
    steps:
      - id: 'auth'
        uses: 'google-github-actions/auth@v1'
        with:
          token_format: access_token
          workload_identity_provider: projects/991820976138/locations/global/workloadIdentityPools/github-pool-1879/providers/github-repo
          service_account: gar-pusher@gbo-conf-1.iam.gserviceaccount.com

      ...
      - name: Login to GAR
        uses: docker/login-action@v2
        with:
          registry: europe-west4-docker.pkg.dev/gbo-conf-1/repo-1
          username: oauth2accesstoken
          password: ${{ steps.auth.outputs.access_token }}
```
<!-- .element: class="big-code" -->

Notes: @Gaetan

##==##
<!-- .slide: -->

## Victory

![h-500 center](./assets/images/applause.webp)

Notes: @Gaetan
