# Système de déploiement epitech

## config serveur

- dockge
- harbor
- traefik
- outils de monitoring
- outils d'authorization sur le token github?


## principe

- api accède au repo git
- les projets doivent être organisés avec packaging/Dockerfile et deployment/compose.yaml
- l'api va envoyer les images a build au registry en ajoutant les labels traefik nécéssaires
- on doit vérifier que les images n'ouvrent pas de ports
- l'api copie la version du repo sur le serveur de déploiement et lance docker compose up
- l'utilisateur devrait pouvoir accéder à ses logs dockge avec son token github.
