#!/bin/bash

# Function to list and select partitions using fzf
select_partition() {
  lsblk -nr -o NAME,SIZE,TYPE | awk '$3=="part" && $1 !~ /^sda/{print "/dev/"$1, "("$2")"}' | \
    fzf --height 40% --prompt "Select partition: " | awk '{print $1}'
}

# Function to list and select mount points using fzf
select_mountpoint() {
  lsblk -nr -o MOUNTPOINT | grep -v '^$' | \
    fzf --height 40% --prompt "Select mount point: "
}

# Loop for the menu
while true
do
  echo "1. Mount a partition"
  echo "2. Unmount a partition"
  echo "3. Exit"
  echo -n "Enter your choice: "
  read ch

  case $ch in
    1)
      echo "Listing available partitions:"
      PARTITION=$(select_partition)

      if [ -z "$PARTITION" ]; then
        echo "No partition selected."
        continue
      fi

      if [ ! -b "$PARTITION" ]; then
        echo "Partition $PARTITION not found."
        continue
      fi

      echo "Contents of /media:"
      ls /media/

      echo -n "Enter a mount point name (e.g., usb): "
      read MNTPT_NAME
      MNTPT="/media/$MNTPT_NAME"

      if mountpoint -q "$MNTPT"; then
        echo "Error: $MNTPT is already mounted."
        continue
      fi

      if [ ! -d "$MNTPT" ]; then
        echo "Mount point doesn't exist. Creating directory $MNTPT"
        sudo mkdir -p "$MNTPT" || { echo "Failed to create mount point directory."; continue; }
      fi

      sudo mount "$PARTITION" "$MNTPT" && echo "Partition mounted at $MNTPT" || echo "Mount failed."
      ;;

    2)
      echo "Mounted partitions:"
      MNTPT=$(select_mountpoint)

      if [ -z "$MNTPT" ]; then
        echo "No mount point selected."
        continue
      fi

      if ! mountpoint -q "$MNTPT"; then
        echo "Error: $MNTPT is not a mounted partition."
        continue
      fi

      sudo umount "$MNTPT" && echo "Partition unmounted from $MNTPT" || echo "Unmount failed."
      ;;

    3)
      echo "Exiting..."
      exit
      ;;

    *)
      echo "Invalid option. Please choose 1, 2, or 3."
      ;;
  esac
done
