<!-- .slide: class="transition-bg-green-3" -->
# Oauth2, one way to do authorization

Notes: @Louis

##==##
<!-- .slide: class="two-column"-->

# What's Oauth2 ?

- Open protocol for handling authorization
- First RFC in oct. 2012
- Uses open standards
  - HTTP
  - JSON
  - JWT

<br/><br/>
<br/><br/>
<br/><br/>  

##--##

<br/><br/>


<div>

```json
{
  "typ": "JWT",
  "alg": "RS256",
  "x5t": "example-thumbprint",
  "kid": "example-key-id"
}
```
```json
{
  "jti": "example-id",
  "sub": "repo:bogaertg/my-app:",
  "aud": "https://github.com/bogaertg",
  "ref": "refs/heads/main",
  "sha": "example-sha",
  "repository": "bogaertg/my-app",
  "repository_owner": "bogaertg",
  "actor": "octocat",
  "workflow": "example-workflow",
  "head_ref": "",
  "base_ref": "",
  "event_name": "workflow_dispatch",
  "iss": "https://token.actions.githubusercontent.com",
  "exp": 1632493867
}
```

</div>

Notes: @Louis

##==##
<!-- .slide -->
# What's Oauth2 ?
## One abstract flow
![center](./assets/images/abstract_flow.png)

Notes: @Louis

Lister les 4 rôles : resource owner, client, resource server et authorization server
Prendre pour exemple une application de gestion de photos

##==##
<!-- .slide -->
# What's Oauth2 ?
## Many grant ypes

* Authorization code (RFC 6749) / PKCE (RFC 7636)
* Device code (RFC 8628)
* Client credential (RFC 6749)
* Token exchange (RFC 8693)
* Your own (RFC 6749)

Notes: @Louis

##==##
<!-- .slide -->
# Oauth2's grants
## Token Exchange (RFC8693)
![center  ](./assets/images/token_exchange.png)

Notes: @Louis
  L'authorization server fait office dans ce cas de "Security Token Service"
