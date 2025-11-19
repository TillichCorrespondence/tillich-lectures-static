# Edition of Tillich’s Lectures on Religion and Culture



* data is fetched from https://github.com/TillichCorrespondence/tillich-lectures-data
* build with [DSE-Static-Cookiecutter](https://github.com/acdh-oeaw/dse-static-cookiecutter)


## Setup

### Prerequisites
* Python 3.x installed (`python3 --version` to check)
* Java (for running Saxon/Ant)
* curl, wget, unzip

### Create and activate venv
```bash
   python3 -m venv venv
   source venv/bin/activate
```

### Install dependencies - (one time) setup
```bash
   pip install -r requirements.txt
```

### Download Saxon and imprint data - (one time) setup
```bash
   ./shellscripts/script.sh
```

### Fetch fresh data from repositories
```bash
   ./fetch_data.sh
```

### Build the site
```bash
   ant
```


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

## Licenses

This project is released under the [MIT License](LICENSE)

### third-party JavaScript libraries
The code for all third-party JavaScript libraries used is included in the `html/vendor` folder, their respective licenses can be found either in a `LICENSE.txt` file or directly in the header of the `.js` file

### SAXON-HE
The projects also includes Saxon-HE, which is licensed separately under the Mozilla Public License, Version 2.0 (MPL 2.0). See the dedicated [LICENSE.txt](saxon/notices/LICENSE.txt)