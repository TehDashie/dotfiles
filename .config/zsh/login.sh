HOSTNAME=`uname -n`
KERNEL=`uname -r`
USERNAME="$(echo "$USER" | sed 's/.*/\u&/')"
ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')
CPU=`awk -F '[ :][ :]+' '/^model name/ { print $2; exit; }' /proc/cpuinfo`
ARCH=`uname -m`
# PACMAN=`checkupdates | wc -l`
#DETECTDISK=`mount -v | fgrep 'on / ' | sed -n 's_^\(/dev/[^ ]*\) .*$_\1_p'`
DISC=`df -h | grep /dev/nvme0n1p2 | awk '{print $5 }'`
HOMEPART=`df -h | grep /dev/nvme0n1p3 | awk '{print $5 }'`
STEAMDRIVE=`df -h | grep /dev/sdb1 | awk '{print $5 }'`
MEMORY1=`free -t -m | grep "Mem" | awk '{print $6" MB";}'`
MEMORY2=`free -t -m | grep "Mem" | awk '{print $2" MB";}'`
MEMPERCENT=`free | awk '/Mem/{printf("%.2f% (Used) "), $3/$2*100}'`

# Detect OS and version
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
    VER=$VERSION_ID
elif type lsb_release >/dev/null 2>&1; then
    # linuxbase.org
    OS=$(lsb_release -si)
    VER=$(lsb_release -sr)
elif [ -f /etc/lsb-release ]; then
    # For some versions of Debian/Ubuntu without lsb_release command
    . /etc/lsb-release
    OS=$DISTRIB_ID
    VER=$DISTRIB_RELEASE
elif [ -f /etc/debian_version ]; then
    # Older Debian/Ubuntu/etc.
    OS=Debian
    VER=$(cat /etc/debian_version)
elif [ -f /etc/SuSe-release ]; then
    # Older SuSE/etc.
    ...
elif [ -f /etc/redhat-release ]; then
    # Older Red Hat, CentOS, etc.
    ...
else
    # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
    OS=$(uname -s)
    VER=$(uname -r)
fi


#Time of day
TIMEDATE=$(date +"%I:%M%p // %A %d %B")
HOUR=$(date +"%H")
if [ $HOUR -lt 12  -a $HOUR -ge 0 ]
then   TIME_OF_DAY="Morning"
elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]
then   TIME_OF_DAY="Afternoon"
else   TIME_OF_DAY="Evening"
fi

#System load
LOAD1=`cat /proc/loadavg | awk {'print $1'}`
LOAD5=`cat /proc/loadavg | awk {'print $2'}`
LOAD15=`cat /proc/loadavg | awk {'print $3'}`

#System uptime
uptime=`cat /proc/uptime | cut -f1 -d.`
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

RESET="\033[0m"
GRAY="\033[1;90m"
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
MAGENTA="\033[1;35m"
CYAN="\033[1;36m"
DARKSLATEGRAY3="\033[38;5;116m"
C_GREY54="\033[38;5;245m"
WHITE="\033[1;37m"

figlet -k $HOSTNAME -f slant | sed 's/^.*$/\t  &/' | lolcat -f .4 -s 1337
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -f .4 -s 1337
echo -e "$RESET   Good $TIME_OF_DAY $USERNAME, it is $TIMEDATE "
echo -e "───────────────────────────────────────────────────────────────" | lolcat -f .4 -s 1337
echo -e "$RESET       $(tput bold)KERNEL$(tput sgr0) $WHITE$RESET $OS $VER"
echo -e "$RESET          $(tput bold)CPU$(tput sgr0) $WHITE$RESET $CPU"
echo -e "$RESET       $(tput bold)MEMORY$(tput sgr0) $WHITE$RESET $MEMORY1 / $MEMORY2 - $MEMPERCENT"
echo -e "$RESET     $(tput bold)LOAD AVG$(tput sgr0) $WHITE$RESET $LOAD1, $LOAD5, $LOAD15"
echo -e "―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――" | lolcat -f .4 -s 1337 # THINNEST
echo -e "$RESET         $(tput bold)ROOT$(tput sgr0) $WHITE$RESET $DISC (Used)"
echo -e "$RESET         $(tput bold)HOME$(tput sgr0) $WHITE$RESET $HOMEPART (Used)"
echo -e "$RESET        $(tput bold)STEAM$(tput sgr0) $WHITE$RESET $STEAMDRIVE (Used)"
echo -e "───────────────────────────────────────────────────────────────" | lolcat -f .4 -s 1337
echo -e "$MAGENTA          UPTIME $B:$W $upDays days $upHours hours $upMins minutes $upSecs seconds " 
echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -f .4 -s 1337

# echo -e "―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――" | lolcat -f .4 -s 1337 # THINNEST
# echo -e "───────────────────────────────────────────────────────────────" | lolcat -f .4 -s 1337 # MEDIUM
# echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | lolcat -f .4 -s 1337 # THICKEST
# echo -e "⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽⍽" | lolcat -f .4 -s 1337 # Weird