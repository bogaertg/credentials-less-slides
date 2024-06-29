<!-- .slide -->
# New mission, new infrastructure we got

* Github repository (Go app)
* CI (Github actions)
* Package/Image registry (Google Artifact Registry)
* Execution environment (Google Kubernetes Engine)
* Data storage system (Google Cloud Storage, PostgreSQL)
<!-- .element: class="list-fragment" -->

Notes: @Alex

##==##
<!-- .slide: -->

## Let's hunt credentials

![ h-600 center](./assets/images/hunt.gif)

Notes: @Gaetan

##==##
## Credentials
### Where are you ?
<!-- .slide: -->

![ h-600 center](./assets/images/global.png)

Notes: @Gaetan

##==##
## Credentials
### Where are you ?
<!-- .slide: -->

![ h-600 center](./assets/images/global_creds1.png)

Notes: @Gaetan

##==##
## Credentials
### Where are you ?
<!-- .slide: -->

![ h-600 center](./assets/images/global_creds2.png)

Notes: @Gaetan

##==##
## Credentials
### Where are you ?
<!-- .slide: -->

![ h-600 center](./assets/images/global_creds3.png)

Notes: @Gaetan

##==##
<!-- slide -->
## Too much credentials !

![ h-600 center](./assets/images/facepalm-chair.gif)

Notes: @Alex

##==##
<!-- .slide: -->
## First step - CI

![center h-400](./assets/images/ci_cred.png)

<br/>

> A service account is a special kind of account used by an application
rather than a person.

Notes: @Gaetan

##==##

<!-- .slide: -->
## First step - CI

![center h-400](./assets/images/ci_cred.png)

* Solutions:
  * Service account key file (RSA private key)

Notes: @Gaetan

##==##
<!-- .slide: -->
## First step - CI

![center h-400](./assets/images/ci_cred.png)

* Solutions:
  * ~~Service account key file~~ (credential-less ❌)

Notes: @Gaetan

##==##
<!-- .slide: -->
## First step - CI

![center h-400](./assets/images/ci_cred.png)

* Solutions:
  * ~~Service account key file~~ (credential-less ❌)

* Idea 💡:
  * Use a Github identity 🤔
<!-- .element: class="list-fragment" -->

Notes: @Gaetan
