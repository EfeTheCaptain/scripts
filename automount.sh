#!/bin/bash

# Loop for the menu
while true
do
    echo "1. Mount a device"
    echo "2. Unmount a device"
    echo "3. Exit"
    echo "Enter your choice: "
    read ch

    case $ch in
        1)
            # List available devices with lsblk
            echo "Listing available devices:"
            lsblk -o NAME,SIZE,TYPE,MOUNTPOINT
            echo "Select a device to mount (e.g., /dev/sdb1): "
            read DEVPATH

            # Check if the device exists
            if [ ! -b "$DEVPATH" ]; then
                echo "Device $DEVPATH not found."
                continue
            fi

            # Show contents of /media
            echo "Contents of /media: "
            ls /media/

            # Ask for mount point
            echo "Enter absolute path to a mount point (e.g., /media/myusb): "
            read MNTPT

            # Create mount point if it doesn't exist
            if [ ! -d "$MNTPT" ]; then
                echo "Mount point doesn't exist. Creating directory $MNTPT"
                mkdir -p "$MNTPT"
            fi

            # Mount the device
            sudo mount "$DEVPATH" "$MNTPT"
            echo "Device mounted at $MNTPT"
            ;;

        2)
            # Show contents of /media
            echo "Contents of /media: "
            ls /media

            # Ask for mount point to unmount
            echo "Enter absolute path to a mount point to unmount device (e.g., /media/myusb): "
            read MNTPT

            # Unmount the device
            if mountpoint -q "$MNTPT"; then
                sudo umount "$MNTPT"
                echo "Device unmounted from $MNTPT"
            else
                echo "Error: $MNTPT is not a mounted device."
            fi
            ;;

        3)
            # Exit the script
            echo "Exiting..."
            exit
            ;;

        *)
            echo "Invalid option. Please choose 1, 2, or 3."
            ;;
    esac
done
