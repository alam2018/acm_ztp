#!/bin/sh
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

oc create -k $SCRIPTDIR/ztp/gitops-subscriptions/argocd/deployment/

oc create -f $SCRIPTDIR/ztp/gitops-subscriptions/argocd/policy/lvm_policy.yaml -n lvm-policy-ns

oc create -f $SCRIPTDIR/ztp/gitops-subscriptions/argocd/policy/localvolume-namespace.yaml

oc create -f $SCRIPTDIR/ztp/gitops-subscriptions/argocd/policy/localstorage-localvolume-policy.yaml -n localvolume-policy-ns
