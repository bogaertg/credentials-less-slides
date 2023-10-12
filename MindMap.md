```mermaid
mindmap
  root((Arrêtons de "rotater" les clés ! Et si on osait le credential-less ?))
    1 ))1.Id vs authn vs authz((
        identification = "Préciser la nature de quelque chose, son type, sa catégorie, pouvoir dire ce que c'est" c.f. Larousse
        authentification = "Dont l'autorité, la réalité, la vérité ne peut être contestée." c.f. le robert
            facteurs d'authentification pour les êtres humains
                connaissance = secret partagé = anecdote privée, mot de passe, etc
                possession = carte d'identité, passeport, acte de naissance, etc
                constitution = empreinte digitale, emprinte rétinienne, ADN, etc
            facteurs d'authentification pour les applications
                connaissance = API key / token JWT / etc 
                utilisation de cryptographie car facile à deviner
        autorisation = "donner à un acteur la permission, le droit de faire quelque chose, rendre possible son action, lui permettre d'user de quelque chose" c.f. larousse
    2 ))2.Use case((
        CI/CD
        GCP
        GKE
        PG
    2. Protocoles d'identitication
      1. Oauth2 et le token exchange
      2. la fédération d'identité
    3. La fédération d'identité dans les vrais outils de la vraie vie de tous les jours
      1. GCP (workload identity)
      2. Kubernetes
      3. Github
      4. Vault
    4. Comment gérer les cas où la fédération d'identité n'est pas possible ?
      1. Injection et rotation de secrets via Vault Operator
      2. Vault dynamic secret pour les bases de données
```

-----------------------
------- USECASE -------
-----------------------


```mermaid
sequenceDiagram
    Github Actions (Github)->>Github Actions (Github): Build docker image
    Github Actions (Github)->>Artifact Registry (GCP): Push docker image on GAR
    note over Github Actions (Github), Artifact Registry (GCP): Workload identity federation
    note over Github Actions (Github), Artifact Registry (GCP): Using Github supplied JWT token
    Kubernetes (GCP)->>Artifact Registry (GCP): Pull docker image
    note over Kubernetes (GCP), Artifact Registry (GCP):  Rights on GKE nodes SA
    Kubernetes (GCP)->>MyApp (Kubernetes): Deploy
    MyApp (Kubernetes)->>Cloud storage (GCP): Push file on bucket
    note over MyApp (Kubernetes), Cloud storage (GCP): Workload identity
    note over MyApp (Kubernetes), Cloud storage (GCP): Using kubernetes supplied JWT token
    Kubernetes (GCP)->>Vault Operator (Kubernetes): Deploy
    Vault Operator (Kubernetes)->>Vault (Vault): Auth Kube
    Vault Operator (Kubernetes)->>Vault (Vault): Sync Static Secret
    Vault Operator (Kubernetes)->>Vault (Vault): Sync Dynamic Secret
    Vault Operator (Kubernetes)->>MyApp (Kubernetes): Inject database auth
    MyApp (Kubernetes)->>Postgresql (postgresql): Write lines
    
```

Credential Github -> GCP (GAR) => Workload identity federation
GKE -> pull image docker from gar (authz sa node)
POD => Bucket => Workload identity

Vault:
Auth Kubernetes => Token exchange
Secret statique
Secret dynamique Postgresql


# Contents

0. Le fil rouge (la démo)
1. Authz vs Autn  (@Louis)
2. Oauth2 & TokenExchange (@Louis)
3. Application Google Cloud (ou autre csp)
   4. Workload identity Federation  (@Gaetan)
      5. Démo Github / Google (@Gaetan)
   6.  Workload identity (GKE) (@Gaetan)
      7. Démo GKE/ GCS (@Gaetan)
8. .....
   9. Vault (@Alex)
      10. Injection et rotation de secrets via Vault Operator
      11. Demo Vault dynamic secret pour les bases de données
