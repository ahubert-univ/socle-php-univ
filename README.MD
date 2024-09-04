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

<<<<<<< Updated upstream
Les sous-domaines locaux à utiliser sont maintenant `*.docker.localhost`.

## Fonctionnement

L'exécution de ce projet est basée sur des commandes `Make`.
=======
- Instaler **dans votre linux WSL make**
  - `sudo apt-get update`
  - `sudo apt-get install make`
>>>>>>> Stashed changes

Vous devez donc installer le binaire sur votre distribution Linux (WSL) .

Voici la commande pour installer make sur Ubuntu

<<<<<<< Updated upstream
```shell
sudo apt-get install make
=======
  ## Les options
      - Url par defaut est  php.docker.localhost
        Pour la modifier utiliser option make create_project ... url_website="url.docker.localhost"
      - Env par defaut est  dev
        Pour la modifier utiliser option make create_project ... env="dev-prod"
      - Les addons de qualitée sont chargés par defaut
        Pour les desactiver utiliser l'option make create_project ... enable_quality="false"
      - PhpVersion par defaut est 8.3-fpm
        Pour modifier la version  make create_project ... phpversion="8.3"
        ATTENTION LES VERSIONS INF A 8.0 ne fontionne par pour des raisons de xdebug
      - Désactiver le webserver par defaut on utilise le webserver symfony
        Pour le désactiver et mettre votre propre webserser make create_project ... enable_local_webserser="false"

  ## Override Dockerfile
      Si vous souhaitez ajouter des instructions à votre dockerfile 
      vous pouvez le faire dans le Dockerfile de votre projet.
    
    Puis relancer `make create_project project=<folder>`
    
  ## Override docker-compose
      Si vous souhaitez ajouter des instructions à votre docker-compose.yml 
      vous pouvez le faire dans le docker-compose.yml de votre projet.
    
  Puis relancer `make create_project project=<folder>`

# Lancer votre projet

- `Make start project=<folder>` permet de lancer votre projet


# Les autres commandes make


- `make` l'ensemble des commandes
- `make down` stop votre projet
- `make bash_php` bash de votre container php


# XDEBUG

Xdebug est intégré et paramètré dans la stack. Vous devez faire le nécessaire dans votre IDE préféré.


# Modifier php.ini

Vous utilisez la version dev de la stack en local. C'est donc le php.ini-development qui est chargé par defaut.
Si vous souhaitez modifier des valeurs du fichier php.ini

- Créer un fichier php.ini à la racine de votre repertoire de travail
- Ne saisissez que les valeurs que vous souhaitez surcharger.
- Relancer vos containers
 ```
make down
make start project=<folder name>
>>>>>>> Stashed changes
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