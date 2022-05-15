# Decred Services Umbrel Support
The intent of this branch is to add support for decred services to umbrel. Many already use umbrel as their btc node and to support various other services.  Adding support to umbrel will allow them to use one system/service to host all of their services.  

## Current Status
- testing has been performed using a VM
- dcrd has been received basic testing and functions properly
- support for dcrdata is currently a work in progress
- **This branch has not been fully tested and does not function. DO NOT USE unless you understand umbrel and docker**

## To Be Added / Investigated
- All other decred services
- Support for base decred installation (dcrd) and to select options for other services.  Currently dcrdata (and others) would be installed when dcrd is installed.  Many users hardware may not support running dcrdata along with the host of other services running on their umbrel.  This could be done by having each decred service as a seperate app which would be the normal umbrel convention or through bash scripting.  The most suitable path will be determined once dcrdata is functioning properly.
- testing on typical umbrel SBC hardware; raspberry pi, rockpro64, etc...