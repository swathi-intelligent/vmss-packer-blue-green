#!/bin/bash

# Create Resource group
az group create -n vmss-blue-green-rg -l southeastasia

# Create Service principal which will be used by packer
az ad sp create-for-rbac -n "azdevops-vmms-deploy" 

