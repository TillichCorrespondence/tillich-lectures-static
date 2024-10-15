# Edition of Tillich’s Lectures on Religion and Culture



* data is fetched from https://github.com/TillichCorrespondence/tillich-lectures-data
* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)


## initial (one time) setup

* run `./shellscripts/script.sh`
* run `./fetch_data.sh`
* run `ant`


## start dev server

* `cd html/`
* `python -m http.server`
* go to [http://0.0.0.0:8000/](http://0.0.0.0:8000/)

## publish as GitHub Page

* got to https://https://github.com/TillichCorrespondence/tillich-lectures-static/workflows/build.yml 
* click the `Run workflow` button


## dockerize your application

* To build the image run: `docker build -t tillich-lectures-static .`
* To run the container: `docker run -p 80:80 --rm --name tillich-lectures-static tillich-lectures-static`
* in case you want to password protect you server, create a `.htpasswd` file (e.g. https://htpasswdgenerator.de/) and modifiy `Dockerfile` to your needs; e.g. run `htpasswd -b -c .htpasswd admin mypassword`

### run image from GitHub Container Registry

`docker run -p 80:80 --rm --name tillich-lectures-static ghcr.io/TillichCorrespondence/tillich-lectures-static:main`