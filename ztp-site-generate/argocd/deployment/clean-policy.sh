#!/bin/sh
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

POLICY_LOCATION=/home/kni/acm/gitops/acm_ztp/ztp/gitops-subscriptions/argocd/policy
POLICY_GEN_TEMPLATE=/home/kni/acm/gitops/acm_ztp/ztp/gitops-subscriptions/argocd/policygentemplates

oc delete -f $SCRIPTDIR/policies-app.yaml

oc delete -f $SCRIPTDIR/hook-policies-sub-role.yaml

oc delete -f $SCRIPTDIR/hook-policies-sub-binding.yaml

oc delete -f $SCRIPTDIR/hook-policies-sub-acm-binding.yaml

oc delete -f $POLICY_GEN_TEMPLATE/common-ranGen.yaml

oc delete -f $POLICY_GEN_TEMPLATE/vdu-sno.yaml

oc delete project --force policies-sub

oc delete project vdu-sno-policies

oc delete -f $POLICY_LOCATION/lvm_policy.yaml

oc delete -f $POLICY_LOCATION/localstorage-localvolume-policy.yaml

oc delete -f $POLICY_LOCATION/localvolume-namespace.yaml