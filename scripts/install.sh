#!/usr/bin/env bash

INSTALL_REPO=https://github.com/darmie/hyperledger-fabric-network-setup

INSTALL_DIR=$HOME/.hyperledger-fabric-network-setup

BINARY_NAME=jbfrabric

if ! command -v git > /dev/null 2>&1; then
    echo """Git is not detected on this system. This script needs it as dependency."""
    exit 1
fi

mkdir -p $INSTALL_DIR
if [ -d "$INSTALL_DIR/.git" ]; then
    echo "=> hyperledger-fabric-network-setup is already installed in $INSTALL_DIR, trying to update the script"
    pushd "$INSTALL_DIR" && git pull $INSTALL_REPO && popd
else
    echo "Downloading hyperledger-fabric-network-setup in $INSTALL_DIR..."
    pushd "$INSTALL_DIR" && git clone $INSTALL_REPO . && popd
fi

rm -rf /usr/local/bin/$BINARY_NAME
ln -s $INSTALL_DIR/scripts/$BINARY_NAME.py /usr/local/bin/$BINARY_NAME
chmod +x /usr/local/bin/$BINARY_NAME

if ! command -v python > /dev/null 2>&1; then
    echo """Python is not detected on this system. This script needs it as dependency.
Install link: https://www.python.org/downloads/
"""
fi

if ! command -v vagrant > /dev/null 2>&1; then
echo """Vagrant is not detected on this system. This script needs it as dependency.
Install link: https://www.vagrantup.com/docs/installation/

You also need the following vagrant plugins: vagrant-docker-compose and vagrant-aws
You can install them with:
vagrant plugin install vagrant-docker-compose && vagrant plugin install vagrant-aws
"""
else
    vagrant plugin list | grep 'vagrant-aws' &> /dev/null
    if [ $? != 0 ]; then
        echo "Installing vagrant plugin vagrant-aws"
        vagrant plugin install vagrant-aws
    else
        echo "Vagrant plugin vagrant-aws is already installed"
    fi

    vagrant plugin list | grep 'vagrant-docker-compose' &> /dev/null
    if [ $? != 0 ]; then
        echo "Installing vagrant plugin vagrant-docker-compose"
        vagrant plugin install vagrant-docker-compose
    else
        echo "Vagrant plugin vagrant-docker-compose is already installed"
    fi
fi

if ! command -v node > /dev/null 2>&1; then
echo """NPM is not detected on this system. This script needs it as dependency.
Install link: https://docs.npmjs.com/getting-started/installing-node
"""
fi

echo "Done. Type jbfabric -h for help."
