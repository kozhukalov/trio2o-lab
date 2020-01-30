
token=$(openstack --os-region-name=RegionOne token issue | awk 'NR==5 {print $4}')

curl -X GET http://127.0.0.1:19996/v1.0/pods -H "Content-Type: application/json" \
  -H "X-Auth-Token: $token" | jq
curl -X POST http://127.0.0.1:19996/v1.0/pods -H "Content-Type: application/json" \
  -H "X-Auth-Token: $token" -d '{"pod": {"pod_name": "RegionOne"}}' | jq
curl -X POST http://127.0.0.1:19996/v1.0/pods -H "Content-Type: application/json" \
  -H "X-Auth-Token: $token" -d '{"pod": {"pod_name": "Pod1", "az_name": "az1"}}' | jq
curl -X GET http://127.0.0.1:19996/v1.0/bindings -H "Content-Type: application/json" \
  -H "X-Auth-Token: $token" | jq
curl -X POST http://127.0.0.1:19996/v1.0/pods -H "Content-Type: application/json" \
  -H "X-Auth-Token: $token" -d '{"pod": {"pod_name": "Pod2", "az_name": "az2"}}' | jq


curl -H "Content-Type: application/json" -H "X-Auth-Token: $token" -X GET http://127.0.0.1:19998/v2.1

# Network

## Pod1

### there is no neutron endpoint in Pod1 that is why we use RegionOne
openstack --os-region-name RegionOne network create net1
openstack --os-region-name RegionOne subnet create --network net1 --subnet-range 10.0.0.0/24 subnet1
openstack --os-region-name RegionOne network list
openstack --os-region-name RegionOne subnet list
openstack --os-region-name RegionOne port list

### the same but using neutron client
neutron --os-region-name RegionOne net-create net1
neutron --os-region-name RegionOne subnet-create --name subnet1 net1 10.0.0.0/24
neutron --os-region-name RegionOne net-list
neutron --os-region-name RegionOne subnet-list
neutron --os-region-name RegionOne port-list

## Pod2
openstack --os-region-name Pod2 network create net1
openstack --os-region-name Pod2 subnet create --network net1 --subnet-range 10.0.0.0/24 subnet1
openstack --os-region-name Pod2 network list
openstack --os-region-name Pod2 subnet list
openstack --os-region-name Pod2 port list

### the same but using neutron client
neutron --os-region-name=Pod2 net-create net2
neutron --os-region-name=Pod2 subnet-create --name subnet2 net2 10.0.0.0/24
neutron --os-region-name=Pod2 net-list
neutron --os-region-name=Pod2 subnet-list
neutron --os-region-name=Pod2 port-list

## Pod4
neutron --os-region-name=Pod4 net-create net4
neutron --os-region-name=Pod4 subnet-create --name subnet4 net4 10.0.0.0/24
neutron --os-region-name=Pod4 net-list
neutron --os-region-name=Pod4 subnet-list
neutron --os-region-name=Pod4 port-list

# Image
openstack --os-region-name RegionOne image list
glance --os-region-name RegionOne image-list

# Flavor
openstack --os-region-name RegionOne flavor create --id 1 --ram 1024 --disk 10 --vcpus 1 test
openstack --os-region-name RegionOne flavor list
### but flavor show does not work

### the same but using nova client
nova --os-region-name RegionOne flavor-create test 1 1024 10 1
nova --os-region-name RegionOne flavor-list

# VMs
# run VM in Pod1
openstack --os-region-name RegionOne server create --image cirros-0.4.0-x86_64-disk --flavor test --network net1 vm1
nova --os-region-name=RegionOne boot --flavor 1 --image $image_id --nic net-id=$net_id vm1

# does not work because there is no network net2 in RegionOne
openstack --os-region-name RegionOne server create --image cirros-0.4.0-x86_64-disk --flavor test --availability-zone az2 --network net2 vm2
# but this does work
nova --os-region-name=RegionOne boot --availability-zone az2 --flavor 1 --image $image_id --nic net-id=$net_id vm2

nova --os-region-name=RegionOne boot --availability-zone az4 --flavor 1 --image $image_id --nic net-id=$net_id vm4

nova --os-region-name=RegionOne list




ovn-nbctl list Logical_Switch
ovn-nbctl list Logical_Switch_Port
ovn-nbctl list ACL
ovn-nbctl list Address_Set
ovn-nbctl list Logical_Router
ovn-nbctl list Logical_Router_Port
ovn-nbctl list Gateway_Chassis

ovn-sbctl list Chassis
ovn-sbctl list Encap
ovn-nbctl list Address_Set
ovn-sbctl lflow-list
ovn-sbctl list Multicast_Group
ovn-sbctl list Datapath_Binding
ovn-sbctl list Port_Binding
ovn-sbctl list MAC_Binding
ovn-sbctl list Gateway_Chassis
