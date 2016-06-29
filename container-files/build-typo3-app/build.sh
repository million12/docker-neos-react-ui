#!/usr/bin/env bash

# This script is used only `docker build` (--post-build hook)
# and then during container start (--post-install and other hooks)
# Path to this script is set via T3APP_USER_BUILD_SCRIPT in Dockerfile.

REACT_UI_PACKAGE_DIR="Packages/Application/Neos.Neos.Ui"
CWD=$(pwd) # current Neos root project dir

log() {
  if [[ "$@" ]]; then echo "[REACT-UI] $@";
  else echo; fi
}

function amendComposer() {
  log "Amending composer.json..."

  # Store original composer.json
  [ -f composer.orig.json ] || cp composer.json composer.orig.json

  # Fill REACT_UI_REPO_URI value in `composer-addons.json`
  # and then inject whole `composer-addons.json` into `composer.orig.json`
  cp -f /build-typo3-app/composer-addons.json .
  sed -i -r "s#REACT_UI_REPO_URI#${REACT_UI_REPO_URI}#g" composer-addons.json
  sed '/"license":/r composer-addons.json' composer.orig.json > composer.json
  rm -f composer-addons.json composer.lock

  log "composer.json updated"
  cat composer.json && log
}

function amendRoutes() {
  sed -i '/Neos subroutes/r /build-typo3-app/Routes-addons.yaml' Configuration/Routes.yaml
  log "Routes.yaml updated"
  cat Configuration/Routes.yaml && log
}

function installReactUI() {
  local REACT_UI_PACKAGE_DIR_PREV=`realpath "${REACT_UI_PACKAGE_DIR}.prev"`

  # Previously installed? Move it (instead of deleting),
  # so we can re-use huge `node_modules` dir to speed things up...
  [ -d $REACT_UI_PACKAGE_DIR ] && {
    rm -rf REACT_UI_PACKAGE_DIR_PREV
    mv -f $REACT_UI_PACKAGE_DIR $REACT_UI_PACKAGE_DIR_PREV
  }

  composer require neos/neos-ui:$REACT_UI_VERSION
  composer install
  cd $REACT_UI_PACKAGE_DIR

  # Restore node_modules (to speed things up) and remove previously installed package
  [ -d $REACT_UI_PACKAGE_DIR_PREV ] && {
    mv $REACT_UI_PACKAGE_DIR_PREV/node_modules .
    rm -rf $REACT_UI_PACKAGE_DIR_PREV
  }

  # NVM is installed in parent image... but need re-initialising?!?
  set +u && source "$NVM_DIR/nvm.sh"

  source Build/init.sh
  npm run build

  cd $CWD
}

rebuildCache() {
  rm -rf Data/Temporary/*
  rm -rf Configuration/PackageStates.php
  rm -rf Configuration/Development/IncludeCachedConfigurations.php

  ./flow flow:cache:flush --force
}



case $@ in
  *--post-build*)
    # TODO: temporary workaround for https://github.com/Ocramius/ProxyManager/issues/321
    # TODO: remove once it's fixed
    composer require zendframework/zend-code:3.0.2

    amendComposer
    amendRoutes
    installReactUI
    ;;

  # Called when container starts, after source code has been installed
  *--post-install*)
    log "BUILD SCRIPT start..."
    if [ "${REACT_UI_FORCE_REINSTALL^^}" = TRUE ]; then
      amendComposer

      # Don't fail image start on errors. Developer probably will want to fix it *when* image starts...
      set +e
      installReactUI
      set -e
    fi
    ;;

  # Called after all configuration settings has been applied
  *--post-settings*)
    rebuildCache
    ;;


  #
  # This is called at the very end of bootstrap process
  #
  *)
    # nothing to do...
esac

log "BUILD SCRIPT completed."
