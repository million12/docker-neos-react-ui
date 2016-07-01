# Neos CMS with [neos/neos-ui](https://github.com/neos/neos-ui) React UI | Docker image
[![Circle CI](https://circleci.com/gh/million12/docker-neos-react-ui/tree/master.svg?style=svg)](https://circleci.com/gh/million12/docker-neos-react-ui/tree/master)

Docker image with Neos CMS and the new back-end UI, 
[neos/neos-ui](https://github.com/neos/neos-ui).
See [Neos + React](https://www.neos.io/blog/neos-and-react.html) article
if you need more background information.

Docker image in Docker Hub: [million12/neos-react-ui](https://hub.docker.com/r/million12/neos-react-ui)


# Features

* [neos/neos-ui](https://github.com/neos/neos-ui) installed
  (dev-master version)
* ability to switch to your fork / branch when container (re)starts - see
  below for ENV vars.


# Usage

You will need working Docker and docker-compose.  
Grab `docker-compose.yml` from this repo (or clone it) and run:

```
docker-compose up
```

Access the new Neos React admin panel on your docker host on port 
`:8182`, e.g.  
[http://docker:8182/neos!](http://docker:8182/neos!) (note `!` at the end).

Refer to the parent image, [million12/typo3-flow-neos-abstract](https://github.com/million12/docker-typo3-flow-neos-abstract)
shall you need any help with further customisation of this image.


# Development

See project repository: [neos/neos-ui](https://github.com/neos/neos-ui).

Shall you need **SFTP access to the container**, uncomment the `dev` 
container  in the `docker-compose.yml` file and provide your GitHub 
username to `IMPORT_GITHUB_PUB_KEYS` env variable. Then access it via  
```
ssh -p 2345 www@docker
```
(or whatever your Docker host is).


# Runtime variables

**REACT_UI_REPO_URI**  
Default: `https://github.com/neos/neos-ui.git`  
Override it with your repository fork if needed.

**REACT_UI_VERSION**  
Default: `dev-master`  
Provide custom composer version, e.g. `dev-task/something`.

**REACT_UI_FORCE_REINSTALL**  
Default: `false`  
Set to `true` to kick off re-install process on container (re)start.
composer.json will be updated with  `REACT_UI_REPO_URI` and `REACT_UI_VERSION`
accordingly. Also, npm stuff will be re-installed and re-built.


# Issues

See project repository: [neos/neos-ui](https://github.com/neos/neos-ui).
