#!/bin/bash
echo "Detect unused kernel"

KernelList=($(dpkg --get-selections|grep linux-image))
kcount=${#KernelList[@]}

UnusedKernel=""
usedKernel=""

for kel in ${KernelList[@]}
do
   if [ $kel != "install" ] && [ $kel != "deinstall" ]; then
	currentkl=$kel
   elif [ $kel = "deinstall" ]; then
	UnusedKernel="$UnusedKernel $currentkl"
   else
	usedKernel="$usedKernel $currentkl"
   fi
done
if [ -z "$UnusedKernel" ]; then
  echo "No unused kernel"
else
  echo "Unused kernel is:$UnusedKernel"
  read -p "Do you want delete these uninstalled kernel images(Y/n):"

  if [ $REPLY != "n" ]; then
     echo "begin clean"
     ukl=($UnusedKernel)
     for ul in ${ukl[@]}
     do
        apt-get purge $ul
     done
  fi
fi

currentKernelRelease=$(uname -r)
cv=${currentKernelRelease%%-generic}
uks=($usedKernel)
for uk in ${uks[@]}
do
  if echo $uk|grep -q $cv
  then
    echo "This kernel $uk is your current used"
  elif [ $uk = "linux-image-generic" ]; then
    echo "Skip generic"
  else
    apt-get purge $uk
  fi
done
echo "Boot clean complete"
