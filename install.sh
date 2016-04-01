platform=none
UNAME=`uname`
case "$UNAME" in
  Linux)
    platform=linux
  ;;
  FreeBSD)
    platform=freebsd
  ;;
esac

if [ "$platform" == linux ]; then
  UNAME=`uname -a`
  if [[ $UNAME =~ Debian ]]; then # if "Debian" in `uname -a` then
    platform=debian
  else
    platform=rhel
  fi
  UNAME=`uname -m`
  if [ "$UNAME" == x86_64 ]; then
    UNAME=64
  else
    UNAME=32
  fi
  platform="$platform$UNAME"
fi

case "$platform" in
  debian64)
    sudo apt-get install lib32gcc1
  ;;
  rhel32)
    sudo apt-get install glibc libstdc++
  ;;
  rhel64)
    yum install glibc.i686 libstdc++.i686
  ;;
esac

# We create a new user who will install and run the server, as it is a security risk to run servers as root.
useradd -m steam

cd ~/
test -e steamcmd || mkdir steamcmd
cd steamcmd
wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

tar -xvzf steamcmd_linux.tar.gz

# ./steamcmd.sh +login anonymous +force_install_dir ./server01 +app_update 222860 validate +quit
# Download and install ProMod
cd ~/
test -e ProMod || mkdir promod
cd ProMod
download https://api.github.com/repos/jbzdarkid/ProMod/zipball
chmod +x build.sh && ./build.sh
download http://www.bailopan.net/stripper/files/stripper-1.2.2-linux.tar.gz && tar -xvzf stripper-1.2.2-linux.tar.gz
download https://forums.alliedmods.net/attachment.php?attachmentid=83286?attachmentid=83286 && unzip socket_3.0.1.zip
download https://forums.alliedmods.net/attachment.php?attachmentid=122230&d=1373147952 && unzip l4dtoolz(L4D2)-1.0.0.9h.zip
download http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz
download https://forums.alliedmods.net/attachment.php?attachmentid=143904&d=1428308284 && unzip GeoIPCity-1.1.2.zip
download https://forums.alliedmods.net/attachment.php?attachmentid=115240&d=1359488782 && unzip "builtinvotes 0.5.8.zip"
download https://forums.alliedmods.net/attachment.php?attachmentid=122493&d=1373577556
download http://users.alliedmods.net/~drifter/builds/dhooks/2.0/dhooks-2.0.4-hg82-linux.tar.gz && tar -xvzf dhooks-2.0.4-hg82-linux.tar.gz


# Todo...
# Clone git repo
#   - https://github.com/jbzdarkid/ProMod/archive/master.zip (absolute latest)
#   - https://api.github.com/repos/jbzdarkid/ProMod/zipball (latest release)
# Copy with overwrite into steam install
# Create startup / shutdown scripts
# Start server