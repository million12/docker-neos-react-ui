# Neos CMS UI written in ReactJS | Docker image
[![Circle CI](https://circleci.com/gh/million12/docker-neos-react-ui/tree/master.svg?style=svg)](https://circleci.com/gh/million12/docker-neos-react-ui/tree/master)

Docker image with Neos and the new back-end UI written in React UI.

[million12/neos-react-ui](https://hub.docker.com/r/million12/neos-react-ui)


# Features

* [PackageFactory/PackageFactory.Guevara](https://github.com/PackageFactory/PackageFactory.Guevara) installed
  (dev-master version)
* ability to switch to your fork / branch when container (re)starts


# Usage

You will need working Docker and docker-compose.  
Clone the repo and run:

```
docker-compose up
```

Access it on your docker host on port `:8182`, e.g.  
http://docker.local:8182/che!


# Development

Follow the project repository on [PackageFactory/PackageFactory.Guevara](https://github.com/PackageFactory/PackageFactory.Guevara)

Shall you need SFTP access to the project, uncomment the `dev` container in the `docker-compose.yml`
file and provide your GitHub username to `IMPORT_GITHUB_PUB_KEYS` env variable.
Access it via ssh -p 2345 www@docker.local (or whatever your Docker host is).


# Runtime variables

**REACT_UI_REPO_URI**  
Default: `https://github.com/ryzy/PackageFactory.Guevara.git`  
Override it with your repository fork to have this package re-installed.

**REACT_UI_VERSION**  
Default: `dev-master`  
Provide custom composer version, e.g. `dev-task/something`.

**REACT_UI_FORCE_REINSTALL**  
Default: `false`  
Set to `true` to kick off re-install process. Composer.json will be updated with 
`REACT_UI_REPO_URI` and `REACT_UI_VERSION` accordingly, npm stuff will be
also re-installed and re-built.


# Issues

Ping us on https://github.com/PackageFactory/PackageFactory.Guevara/issues
