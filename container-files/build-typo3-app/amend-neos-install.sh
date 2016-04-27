#!/usr/bin/env bash

# run --post-build hook
. /build-typo3-app/build.sh

amendComposer
amendRoutes

# remove the conflicting FrontendLogin
rm -rf Packages/Plugins/Flowpack.Neos.FrontendLogin

installReactUI

# Copy our custom `build.sh` into Neos root dir,
# so its parts can be executed via hooks on container start
cp -f /build-typo3-app/build.sh .
chown www:www build.sh

