#
# million12/neos-react-ui
#
FROM million12/typo3-flow-neos-abstract:latest
MAINTAINER Marcin Ryzycki marcin@m12.io

ENV \
  T3APP_BUILD_REPO_URL="https://github.com/neos/neos-base-distribution.git" \
  T3APP_BUILD_BRANCH=master \
  T3APP_NEOS_SITE_PACKAGE=TYPO3.NeosDemoTypo3Org \
  REACT_UI_REPO_URI="https://github.com/PackageFactory/PackageFactory.Guevara.git" \
  REACT_UI_VERSION=dev-master \
  REACT_UI_FORCE_REINSTALL=false

RUN \
  yum install -y jq

ADD container-files /

# Hook into T3APP_USER_BUILD_SCRIPT with our custom script
RUN \
  export T3APP_USER_BUILD_SCRIPT=/build-typo3-app/amend-neos-install.sh && \
  . /build-typo3-app/pre-install-typo3-app.sh
