
Building configuration...

Current configuration : 20102 bytes
!
! Last configuration change at 18:28:31 UTC Wed Oct 16 2019 by admin
!
version 16.6
no service pad
service timestamps debug datetime msec
service timestamps log datetime msec show-timezone
service password-encryption
no platform punt-keepalive disable-kernel-core
!
hostname cat_9k_2
!
!
vrf definition Mgmt-vrf
 !
 address-family ipv4
 exit-address-family
 !
 address-family ipv6
 exit-address-family
!
enable secret xxxxxxxx
!
aaa new-model
!
!
aaa group server radius dnac-client-radius-group
 server name dnac-radius_200.200.200.42
 ip radius source-interface Loopback0
!
aaa group server tacacs+ dnac-network-tacacs-group
 server name dnac-tacacs_200.200.200.44
!
aaa authentication login default local
aaa authentication login VTY_authen group dnac-network-tacacs-group local
aaa authentication dot1x default group dnac-client-radius-group
aaa authorization exec default local 
aaa authorization exec VTY_author group dnac-network-tacacs-group local if-authenticated 
aaa authorization network default group dnac-client-radius-group 
aaa accounting update newinfo periodic 2880
aaa accounting identity default start-stop group dnac-client-radius-group
aaa accounting exec default start-stop group dnac-network-tacacs-group
!
!
!
!
!
aaa server radius dynamic-author
 client 200.200.200.42 server-key 7 071C294D40584B56
!
aaa session-id common
switch 1 provision c9300-24ux
!
!
!
!
ip routing
!
ip name-server 200.200.200.70 200.200.200.80
ip domain name dcloud.at.com
!
!
!
!
!
!
!
!
!
!
!
flow exporter 10.10.20.101
 destination 10.10.20.101
!
access-session mac-move deny
device-tracking tracking
!
device-tracking policy IPDT_MAX_10
 limit address-count 10
 no protocol udp
 tracking enable
!
!
crytpo pki xxxxxxx
 enrollment selfsigned
certificate xxxxxxxxx
 revocation-check none
rsakeypair TP-self-signed- xxxxxxxx
!
crytpo pki xxxxxxx
 enrollment mode ra
 enrollment terminal
 usage ssl-client
 revocation-check crl
!
crytpo pki xxxxxxx
 enrollment mode ra
 enrollment terminal
 usage ssl-client
 revocation-check crl none
!
!
certificate xxxxxxxxx
certificate xxxxxxxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
quit
certificate xxxxxxxxx
certificate xxxxxxxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
quit
certificate xxxxxxxxx
certificate xxxxxxxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
xxxx  xxxxx  xxxx  xxxx  xxxx
quit
!
!
!
diagnostic bootup level minimal
spanning-tree mode rapid-pvst
spanning-tree extend system-id
service-template webauth-global-inactive
 inactivity-timer 3600 
service-template DEFAULT_LINKSEC_POLICY_MUST_SECURE
 linksec policy must-secure
service-template DEFAULT_LINKSEC_POLICY_SHOULD_SECURE
 linksec policy should-secure
service-template DEFAULT_CRITICAL_VOICE_TEMPLATE
 voice vlan
dot1x system-auth-control
!
username xxxxxx
username xxxxxx
!
redundancy
 mode sso
!
!
!
!
class-map match-any system-cpp-police-topology-control
  description Topology control
class-map match-any system-cpp-police-sw-forward
  description Sw forwarding, L2 LVX data, LOGGING
class-map match-any system-cpp-default
  description DHCP Snooping, EWLC control, EWCL data 
class-map match-any system-cpp-police-sys-data
  description Learning cache ovfl, Crypto Control, Exception, EGR Exception, NFL SAMPLED DATA, RPF Failed
class-map match-any system-cpp-police-punt-webauth
  description Punt Webauth
class-map match-any system-cpp-police-l2lvx-control
  description L2 LVX control packets
class-map match-any system-cpp-police-forus
  description Forus Address resolution and Forus traffic
class-map match-any system-cpp-police-multicast-end-station
  description MCAST END STATION
class-map match-any system-cpp-police-multicast
  description Transit Traffic and MCAST Data
class-map match-any system-cpp-police-l2-control
  description L2 control
class-map match-any system-cpp-police-dot1x-auth
  description DOT1X Auth
class-map match-any system-cpp-police-data
  description ICMP redirect, ICMP_GEN and BROADCAST
class-map match-any system-cpp-police-stackwise-virt-control
  description Stackwise Virtual
class-map match-any system-cpp-police-control-low-priority
  description General punt
class-map match-any non-client-nrt-class
class-map match-any system-cpp-police-routing-control
  description Routing control
class-map match-any system-cpp-police-protocol-snooping
  description Protocol snooping
class-map match-any system-cpp-police-system-critical
  description System Critical and Gold pkt
!
policy-map system-cpp-policy
 class system-cpp-police-l2-control
  police rate 500 pps
 class system-cpp-police-routing-control
  police rate 1800 pps
 class system-cpp-police-control-low-priority
  police rate 200 pps
!
! 
!
!
!
!
!
!
!
!
!
!
!
!
interface Loopback0
 ip address 10.2.2.4 255.255.255.0
!
interface GigabitEthernet0/0
 vrf forwarding Mgmt-vrf
 no ip address
 shutdown
 speed 1000
 negotiation auto
!
interface TenGigabitEthernet1/0/1
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/2
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/3
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/4
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/5
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/6
 description changed by DNAC
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/7
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/8
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/9
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/10
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/11
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/12
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/13
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/14
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/15
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/16
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/17
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/18
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/19
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/20
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/21
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/22
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/23
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/0/24
 description changed by DNAC
 device-tracking attach-policy IPDT_MAX_10
!
interface GigabitEthernet1/1/1
 device-tracking attach-policy IPDT_MAX_10
!
interface GigabitEthernet1/1/2
 device-tracking attach-policy IPDT_MAX_10
!
interface GigabitEthernet1/1/3
 device-tracking attach-policy IPDT_MAX_10
!
interface GigabitEthernet1/1/4
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/1/1
 description P2P link cs3850
 no switchport
 ip address 10.10.22.70 255.255.255.252
!
interface TenGigabitEthernet1/1/2
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/1/3
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/1/4
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/1/5
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/1/6
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/1/7
 device-tracking attach-policy IPDT_MAX_10
!
interface TenGigabitEthernet1/1/8
 device-tracking attach-policy IPDT_MAX_10
!
interface FortyGigabitEthernet1/1/1
 device-tracking attach-policy IPDT_MAX_10
!
interface FortyGigabitEthernet1/1/2
 device-tracking attach-policy IPDT_MAX_10
!
interface Vlan1
 ip address 10.10.22.113 255.255.255.240
!
router ospf 4
 network 10.10.22.0 0.0.0.255 area 1
!
ip forward-protocol nd
ip http server
ip http authentication local
ip http secure-server
ip http max-connections 16
ip http client source-interface TenGigabitEthernet1/1/1
ip tacacs source-interface Loopback0
!
ip ssh source-interface TenGigabitEthernet1/1/1
ip ssh version 2
!
ip radius source-interface Loopback0 
!
ip access-list standard ACL_NAME_PLACEHOLDER
 remark test
 permit any
!
logging host 10.10.20.101
logging host 10.10.20.103
logging host 10.10.20.104
logging host 11.22.33.44
logging host 200.200.200.90
!
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
snmp-server xxxxxxxx
tacacs server dnac-tacacs_200.200.200.44
 address ipv4 200.200.200.44
key xxxxxx
 timeout 2
!
!
radius-server attribute 6 on-for-login-auth
radius-server attribute 6 support-multiple
radius-server attribute 8 include-in-access-req
radius-server attribute 25 access-request include
radius-server attribute 31 mac format ietf upper-case
radius-server attribute 31 send nas-port-detail mac-only
radius-server dead-criteria time 5 tries 3
radius-server deadtime 3
!
radius server dnac-radius_200.200.200.42
 address ipv4 200.200.200.42 auth-port 1812 acct-port 1813
 timeout 2
 retransmit 1
 pac key 7 13161F13055D5679
!
!
control-plane
 service-policy input system-cpp-policy
!
banner motd ^CSuccess is 90%perspiration and 10% inspiration ^C
!
line con 0
 logging synchronous
 stopbits 1
line vty 0 4
 access-class ACL_NAME_PLACEHOLDER in
 privilege level 15
 authorization exec VTY_author
login xxxxxx
 transport input all
line vty 5 15
 access-class ACL_NAME_PLACEHOLDER in
 authorization exec VTY_author
login xxxxxx
 transport input all
!
ntp server 200.200.200.39
!
mac address-table notification mac-move
wsma agent exec
!
wsma agent config
!
wsma agent filesys
!
wsma agent notify
!
event manager applet catchall
 event cli pattern ".*" sync no skip no
 action 1 syslog msg "$_cli_host: $_cli_username $_cli_msg"
!
end

