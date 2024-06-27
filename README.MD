# Docker / Traefik / Portainer

Ce projet permet la mise en place d'une infrastructure logicielle de développement composée de :
* Traefik :
    * Gère le routage du trafic selon le nom de domaine en `*.docker.localhost`
    * Réalise la terminaison SSL pour le HTTPS à partir d'un certificat auto-signé
    * Le routage sur nom de domaine est la seule option vous permettant de faire du SSL validé par votre navigateur
    * Accessible à l'adresse https://traefik.docker.localhost/
* Portainer :
    * Permet de visualiser et d'interagir avec les conteneurs Docker via une interface utilisateur (lancement, arrêt, SSH, visualisation des logs, etc...)
    * Accessible à l'adresse https://portainer.docker.localhost/


## URLs `*.docker.localhost`

Les sous-domaines `*.localhost` étant maintenant résolus dynamiquement par WSL2, nous avons ajouté le support des URLs `*.docker.localhost`.

Les sous-domaines locaux à utiliser sont maintenant `*.docker.localhost`.

## Fonctionnement

L'exécution de ce projet est basée sur des commandes `Make`.

Vous devez donc installer le binaire sur votre distribution Linux (WSL) .

Voici la commande pour installer make sur Ubuntu

```shell
sudo apt-get install make
```

### Liste des commandes disponibles

#### start

```shell
make start
```

Permet d'exécuter le projet. <br />
Cette commande démarre les conteneurs `traefik` et `portainer` `php`.

Pour réaliser un projet php:
  * Créer un dossier dans my-project contenant un sous dossier public (my-php-project/public)
  * Renseigner le nom du dossier dans le fichier docker-compose.yml  ligne 77  .
```shell
FOLDER=my-php-project
```
  * Pour si votre dossier public contient un fichier index.php et index.html le fichier html est prioritaire sur le php
  * Si vous avez besoin de modifier php.ini. Créer un fichier php.ini à la racine de votre projet
my-php-project/php.ini et ajouter uniquement les valeurs modifiées.
  

#### down

```shell
make down
```

Permet d'arrêter le projet.<br />
Cette commande arrête et détruit tous les conteneurs lancés par le projet.

#### test

```shell
make test
```

Permet de tester le fonctionnement de Traefik.<br />
Cette commande, en plus de démarrer les conteneurs `traefik` et `portainer`, démarre un conteneur `hello-world`, accessible à l'adresse https://hello.docker.localhost, et permettant de vérifier le bon fonctionnement de Traefik.

### Global Network

Pour communiquer avec toutes les différentes stacks, un Docker user-defined network a été créé.

Cette création est automatique lorsque vous utilisez `make start`.

Ce réseau sera à déclarer dans tous les `docker-compose.yml` de vos projets et remplacera le réseau `docker bridge` par défaut.

### FAQ

**(Obsolète)** Dans le cas de l'utilisation de Dnsmasq, si vous rencontrez une erreur disant que le port 53 est déjà utilisé, et que systemd est activé sur votre WSL.

```cat /etc/wsl.conf```

```
[boot]
systemd=true
```

Lancez la commande afin de ne pas lancer resolved au démarrage de votre session WSL :

```
sudo systemctl disable systemd-resolved
```

Sauvegardez et faites un `wsl --shutdown` dans un PowerShell pour prendre en compte la modification.

## Certificat auto-signé pour la terminaison SSL

Ce projet inclut un certificat SSL auto-signé. Sa date d'expiration est fixée à 2034.
Vous ne devriez pas avoir à en générer un nouveau, mais si c'est nécessaire, la documentation pour créer un certificat auto-signé se trouve ici : [self-signed-ssl/README.MD](self-signed-ssl/README.MD)