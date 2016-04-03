if [ ! -z "$(which wget)" ]; then
  function download() { wget "$1" -O "$2" ; }
fi
if [ ! -z "$(which curl)" ]; then
  function download() { curl "$1" "$2" ; }
fi

# Determining os and arch
platform=none
UNAME="$(uname)"
case "$UNAME" in
  Linux)
    platform=linux
  ;;
  FreeBSD)
    platform=freebsd
  ;;
esac

if [ "$platform" == linux ]; then
  UNAME="$(uname -a)"
  if [[ $UNAME =~ Debian ]]; then # if "Debian" in `uname -a` then
    platform=debian
  else
    platform=rhel
  fi
  UNAME="$(uname -m)"
  if [ "$UNAME" == x86_64 ]; then
    UNAME=64
  else
    UNAME=32
  fi
  platform="$platform$UNAME"
fi

# Installing dependencies
case "$platform" in
  # debian32)
  debian64)
    sudo apt-get -q -y install lib32gcc1
  ;;
  rhel32)
    sudo apt-get -q -y install glibc libstdc++
  ;;
  rhel64)
    yum -q -y install glibc.i686 libstdc++.i686
  ;;
esac

# Download and install the server
cd ~/
test -e steamcmd || mkdir steamcmd
cd steamcmd
download https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz "steamcmd_linux.tar.gz" && tar -xvzf "steamcmd_linux.tar.gz"
COUNT=0
while [ -d "downloading" ] && [ $COUNT -lt 20 ]; do
  let COUNT=COUNT+1
  ./steamcmd.sh +login anonymous +force_install_dir ../server01 +app_update 222860 +quit
done
STATUS="$(./steamcmd.sh +login anonymous +force_install_dir ../server01 +app_update 222860 validate +quit)"
if [ "${STATUS:(-38)}" != "Success! App '222860' fully installed." ]
  echo "$STATUS"
  echo "L4D2 Server install failed!"
  exit -1
fi
cd ~/
if [ ! -e "server01/srcds_run" ]; then
  echo "$STATUS"
  echo "L4D2 Server install failed!"
  exit -2
fi

# Download, install, and copy over all our dependencies
test -e temp || mkdir temp
cd temp
# Tarballs
download "http://www.gsptalk.com/mirror/sourcemod/mmsource-1.10.6-linux.tar.gz" "mmsource.tar.gz" && tar -xvzf "mmsource.tar.gz"
download "https://www.sourcemod.net/smdrop/1.6/sourcemod-1.6.0-git4525-linux.tar.gz" "sourcemod.tar.gz" && tar -xvzf "sourcemod.tar.gz"
download "http://www.bailopan.net/stripper/files/stripper-1.2.2-linux.tar.gz" "stripper.tar.gz" && tar -xvzf "stripper.tar.gz"
download "http://users.alliedmods.net/~drifter/builds/dhooks/2.0/dhooks-2.0.4-hg82-linux.tar.gz" "dhooks2.tar.gz" && "dhooks2.tar.gz"
# Zipballs
download "https://api.github.com/repos/jbzdarkid/ProMod/zipball" "promod.zip" && unzip "promod.zip" && cd "jbzdarkid-ProMod-a269834" && chmod +x build.sh && ./build.sh && mv
download "https://forums.alliedmods.net/attachment.php?attachmentid=83286?attachmentid=83286" "socket.zip" && unzip "socket.zip"
download "https://forums.alliedmods.net/attachment.php?attachmentid=122230&d=1373147952" "l4dtoolz.zip" && unzip "l4dtoolz.zip"
download "https://forums.alliedmods.net/attachment.php?attachmentid=143904&d=142830828"4 "GeoIPCity.zip" && unzip "GeoIPCity.zip"
download "https://forums.alliedmods.net/attachment.php?attachmentid=115240&d=1359488782" "builtinvotes.zip" && unzip "builtinvotes.zip"
# Uncompressed
download "https://github.com/jacob404/promod/blob/master/Fresh%20Install/addons/sourcemod/extensions/left4downtown.ext.2.l4d2.so?raw=true" "left4downtown.ext.2.l4d2.so"
download "http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz" "GeoIPCity.dat" && mv "GeoIPCity.dat" "~/steamcmd/server01/sourcemod/configs/geoip"
download "https://forums.alliedmods.net/attachment.php?attachmentid=122493&d=1373577556" "smrcon.ext.2.l4d2.so"


# Todo...
# Copy over files into the install directory
# Create startup / shutdown scripts
# Start server (in screen)
# Last line of script should print public ip