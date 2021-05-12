# spotweb-docker

## Introduction
If you like [Spotweb](https://github.com/spotweb/spotweb) (like I do), but hate installing and configuring webservers and databases (like I do) then do as I do and simply use [Docker](https://www.docker.com/) for everything :-)=)

Just for fun I thought to try how easy it is to create a Docker setup for Spotweb using Nginx and Postgres. Why Nginx and Postgres? Because I used those in another project recently, so fewer things to figure out. I never used Nginx (dockerized) with PHP before, but as expected loads of other people already have; so ample examples available.

### Using SQLite rather than PostgreSQL
You can also use this setup with an SQLite (simple file based) database, rather than Postgres. In that case there is no real need for the Postgres container. If you would rather use this setup then remove the appropriate lines in docker-compose.yml as indicated by the comments in there and make sure you choose SQLite for the database instead of PostgreSQL during installation (see below).


## Getting started
You have Docker installed and can do docker-compose, right? OK.

Clone this repository and start the build script:

```commandline
git clone https://github.com/poorting/spotweb-docker
cd spotweb-docker
./build.sh
```

This should clone the Spotweb project, create a directory where the Postgres database will reside and pull/build the necessary docker images. This will take some time and create loads of output on screen that should end with this:
```commandline
Status: Downloaded newer image for nginx:latest
Creating spotweb_db  ... done
Creating spotweb_php ... done
Creating spotweb_nginx ... done
```
All (three) containers should be up and running now. Check this by doing `docker ps`, which should output something like:
```commandline
CONTAINER ID   IMAGE                  COMMAND                  CREATED          STATUS         PORTS                  NAMES
d40974a7f622   nginx:latest           "/docker-entrypoint.…"   13 seconds ago   Up 2 seconds   127.0.0.1:80->80/tcp   spotweb_nginx
ee39679eb9a5   spotweb-docker_php     "docker-php-entrypoi…"   15 seconds ago   Up 4 seconds   9000/tcp               spotweb_php
f686130171e1   postgres:12.0-alpine   "docker-entrypoint.s…"   15 seconds ago   Up 3 seconds   5432/tcp               spotweb_db
```
## Configuring Spotweb

Point your browser to [http://localhost/install.php](http://localhost/install.php).
This shows the first install page, checking if everything is OK:
<img src="https://github.com/poorting/spotweb-docker/raw/main/img/spotweb1.png" width="75%" target="_blank">

Click Next <br/>
<img src="https://github.com/poorting/spotweb-docker/raw/main/img/spotweb2.png" width="100%" target="_blank">

On this page choose PostgreSQL, and change the server to `spotweb_db`. The rest can be left as is. Click Verify database to check everything is indeed working and go to the next page.

**NB**: *If you opted for not using PostgreSQL but using the file based SQLite instead: choose SQLite on this page rather than PostgreSQL. No further changes are needed for the rest of the installation.*

<img src="https://github.com/poorting/spotweb-docker/raw/main/img/spotweb3.png" width="100%" target="_blank">

Enter the (account) details for your usenet provider and check with the Verify usenet server button. <br/>
If everything is OK, this will take you to the last install page:

<img src="https://github.com/poorting/spotweb-docker/raw/main/img/spotweb4.png" width="100%" target="_blank">

Choose Single user here. Since the Nginx server is bound to 127.0.0.1 (localhost), having a Shared (or even Public) usage setup doesn't make much sense anyway; nor is this setup intended to be.

Then fill in all the other things on the page.
Finally click Create system. This will take a few moments.

<img src="https://github.com/poorting/spotweb-docker/raw/main/img/spotweb5.png" width="100%" target="_blank">

Follow the link to visit your Spotweb. On that page go to Settings:

<img src="https://github.com/poorting/spotweb-docker/raw/main/img/spotweb6.png" width="50%" target="_blank">

On the Retrieve tab choose a more suitable date for 'Retrieve spots after...', the default of 10 years or so is way way beyond any retention periode of a normal usenet server...
After confirming the change you may get a warning rather than the main page, simply go to [http://localhost](http://localhost) again.
<p>
<img src="https://github.com/poorting/spotweb-docker/raw/main/img/spotweb7.png" width="100%" target="_blank">
</p>

## First retrieval
The first retrieval will take a long time, which may lead to time-out errors if you  start it from the webpage (*Retrieve* button on the bottom left). 

By starting the retrieve command from the command line in the PHP container this will not happen and will also give you more of an idea what's going on (because of the output produced). You can do this with the following command:

`docker exec -it spotweb_php php retrieve.php` 

This will definitely take a long time (over an hour in my experience), so grab yourself a
(number of) cup)(s) of coffee or tea.

For later updates you can use the *Retrieve* button, although you can also use the same command again if you prefer.

## Stopping and starting

If your docker service starts at boot then these containers will be started as well.

If you only want to run these containers when making use of Spotweb, then you can start and stop them from the command line in the `spotweb-docker` directory (where the `docker-compose.yml` file is).

For stopping the containers:
```commandline
docker-compose down
```

For starting the containers:
```commandline
docker-compose up -d
```

If you want to see the log output from the containers, do:
```commandline
docker-compose logs -f
```



