#!/bin/bash

echo "************* Setting Variables from opts"

while getopts ":r:b:g:p" opt; do
  case $opt in
    r) RESOURCE_GROUP="$OPTARG"
    ;;
    b) BLUE_VMSS_NAME="$OPTARG"
    ;;
    g) GREEN_VMSS_NAME="$OPTARG"
    ;;
    p) LOAD_BALANCER_BLUE_BACKEND_POOL_ID="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done


set -x

## IF BLUE VMSS EXISTS REMOVE IT FROM BLUE BACKEND POOL
# ------------------------------------------------------
if [  ! -z "$BLUE_VMSS_NAME" ]
then

echo "Removing Blue VMSS from blue backend pool ..."

# Remove active blue vmss from blue backend pool
az vmss update -g $RESOURCE_GROUP -n $BLUE_VMSS_NAME --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools 0

echo "Blue VMSS removed from blue backend pool"
fi
# ------------------------------------------------------



## REMOVE GREEN VMSS FROM GREEN BACKEND POOL
# ------------------------------------------------------
echo "Removing Green VMSS from Green backend pool ..."

# Remove new green vmss from green backend pool
az vmss update -g $RESOURCE_GROUP -n $GREEN_VMSS_NAME --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools 0

# Remove new green vmss from green nat pool
az vmss update -g $RESOURCE_GROUP -n $GREEN_VMSS_NAME --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerInboundNatPools 0

echo "Green VMSS removed from Green backend pool"
# ------------------------------------------------------


# ADD GREEN VMSS TO BLUE BACKEND POOL
# ------------------------------------------------------
echo "Adding Green VMSS to backend pool ..."

# Add new green vmss to blue backend pool
az vmss update -g $RESOURCE_GROUP -n $GREEN_VMSS_NAME --add virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools "$LOAD_BALANCER_BLUE_BACKEND_POOL_ID"
# ------------------------------------------------------