#!/bin/sh
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

oc create -k $SCRIPTDIR/ztp/gitops-subscriptions/argocd/deployment/

oc create -k $SCRIPTDIR/ztp/gitops-subscriptions/argocd/policy/
