## Script to find best MTU for WG

Because having the best MTU set is a big gamechanger for WireGuard
i was searching for a easy solution to find the best MTU. Found some solutions
with heatmaps etc. and a lot of extras but not what i wanna have.

I just wanna have a simple fast easy to use solution. Did not found this, so here is it.

This has been tested on openwrt. Please install first iperf3 and bash package:

```
opkg update
opkg install bash
opkg install iperf3
```
```
Start iperf3 Server on Targethost with iperf3 -s
```

```
Usage:
--------------------------------------------------------------------
mtu-test.sh <WG IF Name> <start MTU> <stop MTU> <Target WG Server> <Format CSV/PLAIN>

Example:
./mtu-test.sh WGTEST 1200 1500 10.200.50.1 CSV
--------------------------------------------------------------------
```

After Script is finished or gets interrupted it will restore the orginal MTU of the Interface.

Use it your own Risk...

Alexander


-------------------------------------------------------------------------------------------
Here a sample output:
```
root@GE:~# ./mtu-test.sh ZH 1200 1500 10.200.40.1 CSV
Device: ZH
Target Host: 10.200.40.1
Filetype is set to: CSV
Data gets written to: /tmp/wg-mtu-test.csv
-----------------------
MTU: 1200
SPD: 97.0 Mbps
-----------------------
MTU: 1201
SPD: 86.8 Mbps
-----------------------
MTU: 1202
SPD: 95.4 Mbps
-----------------------
MTU: 1203
SPD: 96.3 Mbps
-----------------------
MTU: 1204
SPD: 97.1 Mbps
-----------------------
MTU: 1205
SPD: 95.1 Mbps
-----------------------
...
```
