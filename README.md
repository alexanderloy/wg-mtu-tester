## Script to find best MTU for WG

Because having the best MTU set is a big Gamechanger for WireGuard
i was searching for a easy Solution to find it. Found some Solutions
with heatmaps etc. but not what i wanna have.

I just wanna have a simple fast easy to install Solution. Did not found this, so here is it.

This has been tested on openwrt. Please install first iperf3 and bash package:

```
opkg update
opkg install bash
opkg install iperf3
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