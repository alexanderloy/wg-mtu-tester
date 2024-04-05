#!/bin/bash
#
# Find Best MTU for WG
# By Alexander Loy <alexander.loy@loy.ch>
#


# File we write output to

file=/tmp/wg-mtu-test

datetime=`date +"%d.%m.%Y %T"`

if [[ -z "$1" || -z "$2" || -z "$3" || -z "$4" ]]
then

echo "mtu-test.sh - Find your best MTU for WG Connection"
echo "-----------------------"
echo "Usage:"
echo "--------------------------------------------------------------------"
echo "mtu-test.sh <WG IF Name> <start MTU> <stop MTU> <Target WG Server> <Format CSV/PLAIN>"
echo
echo "Example:"
echo "./mtu-test.sh WGTEST 1200 1500 10.200.50.1 CSV"
echo "--------------------------------------------------------------------"
else

# do some tests
if (( $3 > 1500 )); then
echo "Stop MTU is to high...."
exit 0
fi
if (( $2 < 1200 )); then
echo "Start MTU is to low...."
exit 0
fi

# get current MTU
MTU=$(< /sys/class/net/$1/mtu)
function handle_interrupt {
    echo "Testing interupted. Exiting..."
    echo "Setting MTU on $ifname back to $MTU"
    ip link set dev $ifname mtu $MTU
    exit 0
}

min=$2
max=$3
ifname=$1
target=$4

echo "Device: $ifname"
echo "Target Host: $4"

if [ $5 = "CSV" ]; then

echo "Filetype is set to: CSV"
file="$file.csv"
echo "Data gets written to: $file"
echo "DateTime; MTU; MBPS;" >> $file

else

file="$file.txt"
echo "Filetype is set to: PLAIN"
echo "Data gets written to: $file"

echo "$datetime - Testing..." >> $file
echo "---------------------------------------" >> $file

fi




while [ $min -le $max ]
do
trap handle_interrupt SIGINT

echo "-----------------------"
echo "MTU: $min"
ip link set dev $ifname mtu $min
output=$( iperf3 -c $4 | grep sender | awk 'END{print $7}' )


if [ $5 = "CSV" ]; then
echo "$datetime;$min;$output" >> $file
else
echo "$min - $output" >> $file
fi

echo "SPD: $output Mbps"


  min=$(( $min + 1 ))
done


fi

# done, restore MTU
ip link set dev $ifname mtu $MTU
echo "-------------------------------------------------"
echo "Testing finished!"
echo "Find your results here: $file"
