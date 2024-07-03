## GKE to google services

![center h-300](./assets/images/gke_gcs_cred.png)

* Solutions:
  * Service account key file
<!-- .element: class="list-fragment" -->

Notes: @Alex

##==##
<!-- .slide: -->

## GKE to google services

![center h-300](./assets/images/gke_gcs_cred.png)

* Solutions:
  * ~~Service account key file~~ (credential-less ❌)

Notes: @Alex

##==##
<!-- .slide: -->

## GKE to google services

![center h-300](./assets/images/gke_gcs_cred.png)

* Solutions:
  * ~~Service account key file~~ (credential-less ❌)
  * Use GKE node service account

Notes: @Alex

##==##
<!-- .slide: -->

## GKE to google services

![center h-300](./assets/images/gke_gcs_cred.png)

* Solutions:
  * ~~Service account key file~~ (credential-less ❌)
  * ~~Use GKE node service account~~ (credential-less ✅) (least privilege ❌) (isolation ❌)

Notes: @Alex

##==##
<!-- .slide: -->

## GKE to google services

![center h-300](./assets/images/gke_gcs_cred.png)

* Solutions:
  * ~~Service account key file~~ (credential-less ❌)
  * ~~Use GKE node service account~~ (credential-less ✅) (least privilege ❌) (isolation ❌)

* Idea 💡:
  * Use Kubernetes identity 🤔
<!-- .element: class="list-fragment" -->

Notes: @Alex

##==##
<!-- .slide: -->

## Workload Identity

* GA since March 16, 2020
* Allows a Kubernetes service account to act as a Google service account

![center h-600](./assets/images/workload_identity.png)

Notes: @Alex

##==##

<!-- .slide: class="with-code" -->

## How to

### Kubernetes

```yaml[|5-6]
apiVersion: v1
kind: ServiceAccount
metadata:
  namespace: kns
  annotations:
    iam.gke.io/gcp-service-account: gcs-bucket@gbo-conf-1.iam.gserviceaccount.com
  name: ksa
```
<!-- .element: class="big-code" -->

Notes: @Alex

##==##

<!-- .slide: class="with-code" -->

## How to

### Google Cloud

```bash[|3]
gcloud iam service-accounts add-iam-policy-binding gcs-bucket@gbo-conf-1.iam.gserviceaccount.com \
    --role roles/iam.workloadIdentityUser \
    --member "serviceAccount:gbo-conf-1.svc.id.goog[kns/ksa]"
```
<!-- .element: class="big-code" -->

Notes: @Alex

##==##

<!-- .slides: -->

## Victory

![h-500 center](./assets/images/applause2.gif)

Notes: @Alex

##==##

<!-- .slide: class="two-column" -->

## ...

![h-500 center](./assets/images/ah.gif)

Notes: @Alex

##--##

<br/><br/><br/><br/><br/>

![h-300](./assets/images/bdd_cred.png)

Notes: @Alex
