#!/usr/bin/env bash

usage() {
    cat <<EOM
    Usage: $(basename "$0") [-h] [-m mountpiont] demo_disk...
        -h Help
        -m mountpoint The mountpoint to use for the demo (default: /tmp/zfs-demo)
        -s the max size of the demo disk (default: 64G)
        demo_disk... The disk(s) to use for the demo
    
    $(basename "$0") is a script for demoing ZFS basics. It will create a pool, a dataset, and a file system.
    It is importent to note that this script will destroy all data on the disk you specify.


EOM
}

MOUNTPOINT=/tmp/zfs-demo
MAX_SIZE=$(echo "64G" | numfmt --from=iec)


while getopts ":hm:s:" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        m)
            echo "MOUNTPOINT: $OPTARG"
            MOUNTPOINT=$OPTARG
            ;;
        s)
            echo "MAX_SIZE: $OPTARG"
            MAX_SIZE=$(echo "$OPTARG" | numfmt --from=iec)
            echo "MAX_SIZE: $MAX_SIZE"
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            ;;
    esac
done

shift $((OPTIND - 1))

DISKS=()

for arg in "$@"; do
    if test -b "$arg"; then
        DISKS+=("$arg")
    else
        echo "Invalid disk: $arg"
        exit 1
    fi
done

DISKS_STRING=$(IFS=' ' ; echo "${DISKS[*]}")

function SourceDemoMagic() {
    # shellcheck source=../../shared/demo-magic.sh
    source ../../shared/demo-magic.sh
}

SourceDemoMagic -d

for disk in "${DISKS[@]}"; do
    # check the disk size
    disk_size=$(lsblk -b --output SIZE -n -d "$disk")
    if [[ $disk_size -gt $MAX_SIZE ]]; then
        echo "Disk $disk is too large. Max size is $(numfmt --to=iec "$MAX_SIZE")"
        exit 1
    fi
done


# create pool
pe "zpool create -f -m '$MOUNTPOINT' zfs-demo $DISKS_STRING"

# create dataset
pe "zfs create zfs-demo/dataset1"

# remove zfs-demo
pe "zpool destroy zfs-demo"

