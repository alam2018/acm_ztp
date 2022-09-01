#!/bin/sh
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

oc delete -k $SCRIPTDIR/ztp/gitops-subscriptions/argocd/deployment/

oc delete -f $SCRIPTDIR/ztp/gitops-subscriptions/argocd/policy/lvm_policy.yaml

oc delete -f $SCRIPTDIR/ztp/gitops-subscriptions/argocd/policy/localstorage-localvolume-policy.yaml

oc delete -f $SCRIPTDIR/ztp/gitops-subscriptions/argocd/policy/localvolume-namespace.yaml