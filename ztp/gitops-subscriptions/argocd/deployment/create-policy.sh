#!/bin/sh
set -x

SCRIPTDIR=$(dirname $(realpath "${BASH_SOURCE[0]}"))


oc create -f $SCRIPTDIR/policies-app.yaml

oc create -f $SCRIPTDIR/hook-policies-sub-role.yaml

oc create -f $SCRIPTDIR/hook-policies-sub-binding.yaml

oc create -f $SCRIPTDIR/hook-policies-sub-acm-binding.yaml