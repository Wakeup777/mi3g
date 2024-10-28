#!/bin/sh
#logger -t vpnc-script "func up start wait 80 sec"
#sleep 80
#logger -t vpnc-script "func up done wait 80 sec"
#viaVPN=`cat /opt/home/admin/ip_list.txt`

cp /opt/home/admin/allyouneed.lst /opt/home/admin/allyouneed.lst.last

echo start 
#wget -q https://antifilter.download/list/allyouneed.lst -O /opt/home/admin/allyouneed.lst
wget -q https://raw.githubusercontent.com/1andrevich/Re-filter-lists/refs/heads/main/ipsum.lst -O /opt/home/admin/allyouneed.lst



#exclude_domain.lst

echo "# exclude_domain.lst" >> /opt/home/admin/ip_list_all.txt
exclude_domain=`cat /opt/home/admin/exclude_domain.lst`
for domain in $exclude_domain
do
for i in `resolveip -4 $domain`
do
ip route add $i  via 192.168.0.1 dev eth3 2>&1 >> /dev/null
done
done

echo "" > /opt/home/admin/ip_list_all.txt




echo "# my_domain_via_Web" >> /opt/home/admin/ip_list_all.txt
my_domain_router=`cat /opt/home/admin/my_domain_via_Web.lst`
for domain in $my_domain_router
do
echo "# $domain" >> /opt/home/admin/ip_list_all.txt
resolveip -4 $domain >> /opt/home/admin/ip_list_all.txt
done



echo "# my_domain_via_router" >> /opt/home/admin/ip_list_all.txt
my_domain=`cat /opt/home/admin/my_domain.lst`
for domain in $my_domain
do
echo "# $domain" >> /opt/home/admin/ip_list_all.txt
resolveip -4 $domain >> /opt/home/admin/ip_list_all.txt
done


echo "#my_ip" >> /opt/home/admin/ip_list_all.txt
cat /opt/home/admin/my_ip.lst >> /opt/home/admin/ip_list_all.txt

echo "#allyouneed.lst" >> /opt/home/admin/ip_list_all.txt
cat /opt/home/admin/allyouneed.lst >> /opt/home/admin/ip_list_all.txt


viaVPN=`cat /opt/home/admin/ip_list_all.txt | grep -v ^# | dos2unix`
IFNAME=tun0
logger -t vpnc-script "start add routes"
for IP in $viaVPN
do
#echo $IP
#echo "ip route add $IP dev $IFNAME 2>&1 >> /dev/null   "
ip route add $IP dev $IFNAME 2>&1 >> /dev/null
done
logger -t vpnc-script "finish add routes"
