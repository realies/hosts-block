#!/bin/bash
set -e
cp -i /etc/hosts{,.backup} | true

files=(
 "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
 "https://mirror1.malwaredomains.com/files/justdomains"
 "http://sysctl.org/cameleon/hosts"
 "https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist"
 "https://s3.amazonaws.com/lists.disconnect.me/simple_tracking.txt"
 "https://s3.amazonaws.com/lists.disconnect.me/simple_ad.txt"
 "https://hosts-file.net/ad_servers.txt"
)

content=$(cat /etc/hosts)
content+=$'\n\n'
for file in "${files[@]}"
do
 content+=$'\n\n'
 content+="# $file"
 content+=$'\n'
 content+=$(curl -s "$file" | grep -vE "^.*#|^$" | awk '{$1=$1};1' | (cut -d " " -f2 || cut -d " " -f1) | grep -vE "localhost|^local$|^ip6-|^broadcasthost$|^0\.0\.0\.0$" | sed "s/^/0.0.0.0 /")
done
echo "$content" > /etc/hosts
echo "Done"
