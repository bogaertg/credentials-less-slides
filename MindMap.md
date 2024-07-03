```mermaid
mindmap
  root((Arrêtons de "rotater" les clés ! Et si on osait le credential-less ?))
    ))Id vs authn vs authz((
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
    ))Use case((
        CI/CD
        GCP
        GKE
        PG
    ))Protocoles d'identitication((
        Oauth2 et le token exchange
        la fédération d'identité
    ))La fédération d'identité dans les vrais outils de la vraie vie de tous les jours((
        GCP - workload identity
        Kubernetes
        Github
        Vault
    ))Comment gérer les cas où la fédération d'identité n'est pas possible ?((
        Injection et rotation de secrets via Vault Operator
        Vault dynamic secret pour les bases de données
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

- Credential Github -> GCP (GAR) => Workload identity federation
- GKE -> pull image docker from gar (authz sa node)
- POD => Bucket => Workload identity

Vault:
- Auth Kubernetes => Token exchange
- Secret statique
- Secret dynamique Postgresql


# Contents

0. Le fil rouge (la démo)
1. Authz vs Autn  (@Alex)
2. Oauth2 & TokenExchange (@Alex)
3. Application Google Cloud (ou autre csp)
    1. Workload identity Federation  (@Gaetan)
        1. Démo Github / Google (@Gaetan)
    2. Workload identity (GKE) (@Gaetan)
        1. Démo GKE/ GCS (@Gaetan)
4. .....
    1. Vault (@Alex)
        1. Injection et rotation de secrets via Vault Operator
        2. Demo Vault dynamic secret pour les bases de données
