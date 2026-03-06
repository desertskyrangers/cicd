#!/bin/bash

mkdir -p "${HOME}/.ssh"
gpg --quiet --batch --yes --decrypt --passphrase=${DSR_GPG_PASSWORD} --output .github/keystore .github/keystore.gpg
gpg --quiet --batch --yes --decrypt --passphrase=${DSR_GPG_PASSWORD} --output $HOME/.ssh/id_rsa .github/id_rsa.gpg
gpg --quiet --batch --yes --decrypt --passphrase=${DSR_GPG_PASSWORD} --output $HOME/.ssh/id_rsa.pub .github/id_rsa.pub.gpg
gpg --quiet --batch --yes --decrypt --passphrase=${DSR_GPG_PASSWORD} --output $HOME/.ssh/known_hosts .github/known_hosts.gpg
chmod 600 "${HOME}/.ssh/id_rsa"
chmod 600 "${HOME}/.ssh/id_rsa.pub"
chmod 600 "${HOME}/.ssh/known_hosts"

#ACM_RELEASE is derived from GITHUB_REF, example values: refs/heads/main, refs/heads/stable
case "${GITHUB_REF}" in
  "refs/heads/main") ACM_RELEASE="latest" ;;
  "refs/heads/stable") ACM_RELEASE="stable" ;;
esac
export PRODUCT_DEPLOY_PATH=/opt/dsr/repo/${ACM_RELEASE}/${ACM_PRODUCT}

echo "Build date=$(date)"
echo "GITHUB_REF=${GITHUB_REF}"
echo "PRODUCT_DEPLOY_PATH=${PRODUCT_DEPLOY_PATH}"

echo "JAVA_DISTRO=temurin" >> $GITHUB_ENV
echo "JAVA_PACKAGE=jdk" >> $GITHUB_ENV
echo "JAVADOC_DEPLOY_PATH=${PRODUCT_DEPLOY_PATH}" >> $GITHUB_ENV
echo "JAVADOC_TARGET_PATH=${PRODUCT_DEPLOY_PATH}/javadoc" >> $GITHUB_ENV
echo "PRODUCT_DEPLOY_PATH=${PRODUCT_DEPLOY_PATH}" >> $GITHUB_ENV
