import { SfeirThemeInitializer } from '../web_modules/sfeir-school-theme/sfeir-school-theme.mjs';

function introSlides() {
  return ['00-intro/00-title.md', '00-intro/02-speaker-ada.md','00-intro/03-speaker-gbo.md', '00-intro/04-intro.md'];
}

function introAuthnAutz() {
  return ['01-intro-authz/00-fil-rouge.md', '01-intro-authz/01-authn-vs-authz.md'];
}

function oauth() {
  return ['02-oauth-token-exchange/00-oauth.md'];
}

function tokenExchange() {
  return [];
}

function gcWorld() {
  return ['04-in-gc-world/00-intro.md', '04-in-gc-world/01-workload-identity-federation.md', '04-in-gc-world/02-workload-identity.md'];
}

function vault() {
  return ["05-vault/00-intro.md", "05-vault/01-demo.md"];
}

function conclusion() {
  return ["06-conclusion/00-intro.md"];
}

function formation() {
  return [
    //
    ...introSlides(),
    ...introAuthnAutz(),
    ...oauth(),
    ...tokenExchange(),//
    ...gcWorld(),
    ...vault(),
    ...conclusion(),
  ].map((slidePath) => {
    return { path: slidePath };
  });
}

SfeirThemeInitializer.init(formation);
