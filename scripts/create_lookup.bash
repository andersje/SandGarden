#!/bin/bash
# this script is horrible inefficient, but it works.  So there.

rm ./named.htc-xen
rm ./named.htc-xen-rev
rm ./names.only
rm ./ips
rm ./combined

awk '/server-name/{print $2}' dhcpd.addon | sed -e 's/"//g' | sed -e 's/;//' > names.only
awk '/fixed-address/{print $2}' dhcpd.addon  | sed -e 's/;//' > ips
paste names.only ips > combined
awk -f awker combined | grep A > forward.lookup
awk -f awker combined | grep PTR > tmp_reverse
sed -e 's/10.10.60.//' tmp_reverse > reverse.lookup

cat > named.htc-xen << EOD
\$TTL 86400
@         0       IN       SOA    lurch.hennepintech.edu. root.lurch.hennepintech.edu. (
                        1         ; Serial
                        28800     ; Refresh
                        14400     ; Retry
                        604800    ; Expire
                        86400)     ; Minimum TTL
          0       IN       NS     lurch.hennepintech.edu.

EOD
cat forward.lookup >> named.htc-xen

cat > named.htc-xen-rev << EOD
\$TTL 86400
@         0       IN       SOA    lurch.hennepintech.edu. root.lurch.hennepintech.edu. (
                        1         ; Serial
                        28800     ; Refresh
                        14400     ; Retry
                        604800    ; Expire
                        86400)     ; Minimum TTL
          0       IN       NS     lurch.hennepintech.edu.
EOD
cat reverse.lookup >> named.htc-xen-rev

