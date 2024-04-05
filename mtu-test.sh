#!/bin/bash
#
# Find Best MTU for WG
# By Alexander Loy <alexander.loy@loy.ch>
#
# This can take up a long time, let it run overnight :)


# File we write output to
file=/tmp/wg-mtu-test.txt

datetime=`date +"%d.%m.%Y %T"`


function handle_interrupt {
    echo "Testing interupted. Exiting..."
    echo "Setting MTU on $4 back to $MTU"
    ip link set dev $4 mtu $MTU
    exit 0
}


if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]]
then

echo "mtu-test.sh - Find your best MTU for WG Connection"
echo "-----------------------"
echo "Usage:"
echo "--------------------------------------------------------------------"
echo "mtu-test.sh <WG IF Name> <start MTU> <stop MTU> <Target WG Server>"
echo
echo "Example:"
echo "./mtu-test.sh WGTEST 1200 1500 10.200.50.1"
echo "--------------------------------------------------------------------"
echo "Output is written to: $file"
echo "--------------------------------------------------------------------"

else

# get current MTU
MTU=$(< /sys/class/net/$1/mtu)

min=$2
max=$3
ifname=$1
target=$4


echo ""
echo "$datetime - Testing..." >> $file
echo "---------------------------------------" >> $file

while [ $min -le $max ]
do
trap handle_interrupt SIGINT

echo "-----------------------"
echo "MTU: $min"
#ip link set dev $4 mtu $min
output=$( iperf3 -c $4 | grep sender | awk 'END{print $7}' )
echo "$min - $output" >> $file

echo "SPD: $output Mbps"


  min=$(( $min + 1 ))
done


fi

# done, restore MTU
ip link set dev $4 mtu $MTU
echo "-------------------------------------------------"
echo "Testing finished!"
echo "Find your results here: $file"
