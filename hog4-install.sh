#!/bin/sh

mkdir -p /root/hogtmp
cd /root/hogtmp/
wget -O image.zip https://cdn.etcconnect.com/Hog4_3-15-1-3142-iso.zip

apt-get install -y unzip

unzip image.zip
mv Hog4*.iso Hog4.iso
rm image.zip

mkdir -p /mnt/hogiso
mount Hog4.iso /mnt/hogiso

apt-get install -y dpkg-dev
mkdir -p /usr/local/hog4-repository
cp -r /mnt/hogiso/pool/* /usr/local/hog4-repository/
cd /usr/local/hog4-repository/
dpkg-scanpackages -m . /dev/null | gzip -9c > Packages.gz

dpkg --add-architecture i386

echo 'deb [trusted=yes] file:/usr/local/hog4-repository ./' >> /etc/apt/sources.list
apt-get update

apt-get install -y libarchive13:i386
apt-get install -y nodm=0.13-2.0
apt-get install -y xserver-xorg-input-libinput=0.23.0-2+hog4deb9u2
apt-get install -y xserver-xorg-video-intel=2:2.99.918+hog4git20161206
apt-get install -y firmware-amd-graphics=20190114-1~bpo9+2
apt-get install -y firmware-misc-nonfree=20190114-1~bpo9+2
apt-get install -y firmware-linux-nonfree=20190114-1~bpo9+2
apt-get install -y firmware-linux=20190114-1~bpo9+2
apt-get install -y linux-image-4.19.0-5-hog4-amd64
apt-get install -y libpam-systemd=232-25+hog4deb9u1 libnss-systemd=232-25+hog4deb9u1 libnss-resolve=232-25+hog4deb9u1 libsystemd0=232-25+hog4deb9u1 systemd=232-25+hog4deb9u1 systemd-sysv=232-25+hog4deb9u1 libsystemd0:i386=232-25+hog4deb9u1 udev=232-25+hog4deb9u1 libudev1=232-25+hog4deb9u1
rm -f /usr/share/doc/libudev1/changelog.Debian.gz
apt-get install -y libudev1:i386=232-25+hog4deb9u1
apt-get install -y udevil
apt-get install -y libinput10:i386
apt-get install -y fxload
apt-get install -y dongleeydib:i386 aksusbd:i386 hog4-base hog4-qdpkg:i386 hog4-thirdparty:i386 hog4-qt5:i386 hog4-boost:i386 hog4-app:i386 hog4-updates:i386 hog4-xcursor hog4-xconfig hog4-systemd-config
#apt-get install -y hog4-sysconfig

umount /mnt/hogiso
rm -r /mnt/hogiso
rm -r /root/hogtmp

mkdir -p /root/.fluxbox
echo '#!/bin/sh\nfbsetbg -c /usr/share/fluxbox/styles/hog4/pixmaps/Background.png &\ndevmon &\n/root/hog4-postinstall.sh &\nexec fluxbox' > /root/.fluxbox/startup
cp /usr/share/hog4-xconfig/fluxbox/config/windowmenu /root/.fluxbox
cp /usr/share/hog4-xconfig/fluxbox/config/menu /root/.fluxbox
cp /usr/share/hog4-xconfig/fluxbox/config/keys /root/.fluxbox
cp /usr/share/hog4-xconfig/fluxbox/config/init /root/.fluxbox

echo "#!/bin/sh" > /root/hog4-postinstall.sh

{
echo 'sleep 10'
echo 'DISPLAY=:0 xterm -e apt-get install -y hog4-sysconfig'
echo 'eth_counter=0' 
echo 'for adapter in /sys/class/net/en*; do'
echo 'local_address=$(cat ${adapter}/address 2>/dev/null)'
echo 'if [ $local_address != 00:00:00:00* ] && [ ! -d "${adapter}/wireless" ];'
echo 'then'
echo 'echo "SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"?*\", ATTR{address}==\"$local_address\", ATTR{type}==\"1\", NAME=\"eth$eth_counter\"" >> /etc/udev/rules.d/99-hog4-ethernet.rules'
echo 'if [ $eth_counter = 0 ];'
echo 'then'
echo 'echo "auto lo\niface lo inet loopback\n\nauto eth$eth_counter\nallow-hotplug eth$eth_counter\niface eth$eth_counter inet static\naddress 172.31.0.1/16\ngateway 172.31.0.1\nnameserver 172.31.0.1\n\n" > /etc/network/interfaces.hog4-sysconfig'
echo 'else'
echo 'echo "auto eth$eth_counter\nallow-hotplug eth$eth_counter\niface eth$eth_counter inet static\naddress 10.0.0.1/8\ngateway 10.0.0.1\n\n" >> /etc/network/interfaces.hog4-sysconfig'
echo 'fi'
echo 'eth_counter=$((eth_counter+1))'
echo 'fi'
echo 'done'
echo 'rm /etc/network/interfaces && ln -s /etc/network/interfaces.hog4-sysconfig /etc/network/interfaces'
echo 'rm /root/hog4-postinstall.sh'
echo "sed -i '/postinstall/d' /root/.fluxbox/startup"
echo "sed -i '/GRUB_VIDEO_BACKEND/d' /etc/default/grub"
echo "grub-mkconfig -o /boot/grub/grub.cfg"
echo 'reboot'
} >> /root/hog4-postinstall.sh
chmod +x /root/hog4-postinstall.sh

reboot

