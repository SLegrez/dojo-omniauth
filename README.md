# README

Dernière mise à jour : 29/04/24

## Gem requises :
- Une gem pour gérer les clés secrètes (ici Figaro)
- devise
- dry-transaction
- omniauth-rails_csrf_protection
- omniauth-facebook
- omniauth-google-oauth2
- omniauth-linkedin-openid
- Bonus : omniauth-github

## Mise en place du fast connect Facebook :
- Créer un compte Facebook Developer « https://developers.facebook.com/ ».
- Créer une app « mon-app-a-moi ».
- Paramétrer les autorisations pour avoir l’email ainsi que le public_profile.
- En développement les redirections « localhost » sont automatiquement autorisées donc pas besoin de whitelister quoi que ce soit.
- Aller dans « Paramètres de l’app » -> Général. Copier/coller « Identifiant de l’application » et « Clé secrète » qui correspondent respectivement aux var d’env « FACEBOOK_APP_ID » & « FACEBOOK_APP_SECRET » et mettre ça dans notre app.

	Pour faire tourner ça en prod il y a d’autres étapes à compléter :
    - Indiquer une url de redirection Omniauth valide. Par exemple « https://www.mon-app-a-moi.com/users/auth/facebook/callback ».
    - Renseigner les URL de politique de confidentialité et de suppression des données utilisateurs (ou l’url de rappel).
    - (Aller dans « Publier » pour voir ce qu’il manque et ensuite dans « Vérification de l’entreprise ». Choisir un compte ou en créer un le cas échéant).

## Mise en place du fast connect Google :
- Créer un projet sur « https://console.developers.google.com ».
- Créer un identifiant en cliquant sur « Créer des identifiants » (en haut) puis « ID client Oauth ». Valider et copier/coller les « GOOGLE_CLIENT_ID » & « GOOGLE_CLIENT_SECRET ».
- Ajouter « http://localhost/users/auth/google_oauth2/callback » dans l’url de redirection autorisée de la configuration de l’identifiant.

## Mise en place du fast connect Linkedin :
- Ne pas utiliser l'ancienne gem « omniauth-linkedin-oauth2 » mais « omniauth-linkedin-openid ». L’ancienne qu’on utilise notamment sur Tantiem n’est plus à jour notamment pour aller taper le endpoint de Linkedin qui a changé.
- Aller sur « https://www.linkedin.com/developers/» et créer une app.
- Aller dans « Auth » et copier/coller les IDs.
- Ajouter « http://localhost:3000/users/auth/linkedin/callback » comme url de retour.
- Activer « Sign In with LinkedIn » dans « Products ».
