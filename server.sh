case "$1" in
  [Ss]tart)
    if [ ! -z "$(which wget)" ]; then
      IP_ADDR="$(wget http://ipinfo.io/ip)"
    fi
    if [ ! -z "$(which curl)" ]; then
      IP_ADDR="$(curl http://ipinfo.io/ip)"
    fi
    SERVER_PATH="$(pwd)/srcds_run"
    case "$((RANDOM % 13))" in
      1)
        START_MAP="c1m1_hotel"
      ;;
      2)
        START_MAP="c2m1_streets"
      ;;
      3)
        START_MAP="c3m1_plankcountry"
      ;;
      4)
        START_MAP="c4m1_milltown_a"
      ;;
      5)
        START_MAP="c5m1_waterfront"
      ;;
      6)
        START_MAP="c6m1_riverbank"
      ;;
      7)
        START_MAP="c7m1_docks"
      ;;
      8)
        START_MAP="c8m1_apartment"
      ;;
      9)
        START_MAP="c9m1_alleys"
      ;;
      10)
        START_MAP="c10m1_caves"
      ;;
      11)
        START_MAP="c11m1_greenhouse"
      ;;
      12)
        START_MAP="c12m1_hilltop"
      ;;
      13)
        START_MAP="c13m1_alpinecreek"
      ;;
    esac
    screen -mdS server01 taskset -c 0 "$SERVER_PATH" -game left4dead2 -tickrate 60 -maxplayers 30 -ip "$IPADDR" +map "$START_MAP" +exec run.cfg
  ;;
  [Ss]top | [Qq]uit)
    screen -r server01 -X quit
  ;;
  [Rr]estart)
    ./server.sh Stop
    ./server.sh Start
  ;;
esac
