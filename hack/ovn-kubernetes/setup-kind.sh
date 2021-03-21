#!/usr/bin/env bash

set -xv
set -eou pipefail

CLUSTER="ovn"
OVN_DIR="ovn-kubernetes-repo"
# TODO if https://github.com/ovn-org/ovn-kubernetes/pull/2112 has landed,
#    we may not need this patch stuff
#PATCH_PATH="patch-fedora33-cg0-enabled.patch"

if [[ ! -d $OVN_DIR ]] ; then
  git clone https://github.com/ovn-org/ovn-kubernetes $OVN_DIR
fi

#cp $PATCH_PATH $OVN_DIR
pushd $OVN_DIR
#  patch -p1 < $PATCH_PATH
  pushd go-controller
      make
  popd

  pushd dist/images
      make ubuntu
  popd

  pushd contrib
      KUBECONFIG=${HOME}/admin.conf ./kind.sh
  popd
popd
