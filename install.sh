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

# Todo...
# Clone git repo
# Copy with overwrite into steam install
# Create startup / shutdown scripts
# Start server