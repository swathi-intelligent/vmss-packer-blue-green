# Remove active blue vmss from blue backend pool
az vmss update -g VMSSBG -n bluevmssorimagename --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools 0

# Remove new green vmss from green backend pool
az vmss update -g VMSSBG -n greeenvmssorimagename --remove virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools 0


# Add new green vmss to blue backend pool
az vmss update -g VMSSBG -n greeenvmssorimagename --add virtualMachineProfile.networkProfile.networkInterfaceConfigurations[0].ipConfigurations[0].loadBalancerBackendAddressPools '{"id": "/subscriptions/<subcriptionId>/resourceGroups/VMSSBG/providers/Microsoft.Network/loadBalancers/<lbName>/backendAddressPools/<backendpoolName'"}'