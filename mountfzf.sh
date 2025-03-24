#!/bin/bash

# Function to list and select devices using fzf
select_device() {
  lsblk -o NAME,SIZE,TYPE,MOUNTPOINT | grep -v "sda" | grep -v "loop" | fzf --height 40% --prompt "Select device: " | awk '{print $1}'
}

# Function to list and select mount points using fzf
select_mountpoint() {
  mount | grep "/media/" | awk '{print $3}' | fzf --height 40% --prompt "Select mount point: "
}

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
      # List available devices with lsblk using fzf
      echo "Listing available devices:"
      DEVPATH=$(select_device)

      if [ -z "$DEVPATH" ]; then
        echo "No device selected."
        continue
      fi

      # Check if the device exists
      if [ ! -b "$DEVPATH" ]; then
        echo "Device $DEVPATH not found."
        continue
      fi

      # Show contents of /media
      echo "Contents of /media: "
      ls /media/

      # Ask for mount point
      echo "Enter a mount point name (e.g., usb): "
      read MNTPT_NAME

      MNTPT="/media/$MNTPT_NAME"

      # Create mount point if it doesn't exist
      if [ ! -d "$MNTPT" ]; then
        echo "Mount point doesn't exist. Creating directory $MNTPT"
        sudo mkdir -p "$MNTPT"
      fi

      # Mount the device
      sudo mount "$DEVPATH" "$MNTPT"
      if [ $? -eq 0 ]; then
        echo "Device mounted at $MNTPT"
      else
        echo "Mount failed."
      fi
      ;;

    2)
      # Unmount using fzf
      echo "Mounted devices under /media:"
      MNTPT=$(select_mountpoint)

      if [ -z "$MNTPT" ]; then
        echo "No mount point selected."
        continue
      fi

      # Unmount the device
      if mountpoint -q "$MNTPT"; then
        sudo umount "$MNTPT"
        if [ $? -eq 0 ]; then
          echo "Device unmounted from $MNTPT"
        else
          echo "Unmount failed."
        fi
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
