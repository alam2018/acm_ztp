#!/bin/sh
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))

oc delete -f $SCRIPTDIR/policies-app.yaml

oc delete -f $SCRIPTDIR/hook-policies-sub-role.yaml

oc delete -f $SCRIPTDIR/hook-policies-sub-binding.yaml

oc delete -f $SCRIPTDIR/hook-policies-sub-acm-binding.yaml

oc delete project --force policies-sub