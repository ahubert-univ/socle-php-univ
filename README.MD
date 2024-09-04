# Stack PHP

Ce projet met en place la Stack PHP sans aucun framework ni CRM que du PHP. Il ne charge pas non plus de serveur WEB (Apache ou Nginx).  
En mode dev vous utiliserez **la server fournit par symfony-cli**.

**Cette stack n'a été testée que sous WSL**


# Pré-requis
Pour faire fonctionner cette stack vous devez:


- Instaler **dans votre linux WSL make**
  - `sudo apt-get update`
  - `sudo apt-get install make`

# Créer Votre premier projet php !

Pour créer un nouveau projet il suffit:
- Lancer la commande `make create_project project=<folder>`

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
```

