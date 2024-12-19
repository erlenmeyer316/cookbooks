#/usr/bin/env bash


haystack_file="fstab"
needle="https://webdav.dickinet.info:1214/erlenmeyerkpxc /home/erlenmeyer316/.kpxc davfs user,noauto,file_mode=600,dir_mode=700 0 1"

if grep -q "${needle}" "$haystack_file"; then
  echo "line exists in file"
else
  echo "adding line to file"
  echo $needle >> $haystack_file
fi
