#!/bin/bash

### USER INPUT VARIABLES
read -p '[OPTIONAL] ENABLE NFS FOR BACKUP [true/FASLE]: ' nfs_backup < /dev/tty
nfs_backup=${nfs_backup:-false}

read -p '[OPTIONAL] ENABLE NFS FOR MEDIA [true/FASLE]: ' nfs_media < /dev/tty
nfs_media=${nfs_media:-false}

if [[ $nfs_backup == true ]]; then
  read -p '[REQUIRED] NFS SERVER IP ADDRESS FOR BACKUP: ' nfs_backup_address < /dev/tty

  if [[ -z $nfs_backup_address ]]; then
    echo "ERROR: NFS SERVER IP ADDRESS FOR BACKUP REQUIRED... Exiting"
    exit 1
  fi

  read -p '[REQUIRED] NFS VOLUME FOR BACKUP: ' nfs_backup_volume < /dev/tty

  if [[ -z $nfs_backup_volume ]]; then
    echo "ERROR: NFS VOLUME FOR BACKUP REQUIRED... Exiting"
    exit 1
  fi

  ### CREATE BACKUP DIRECTORY
  doas mkdir -p /mnt/backup
  doas chown alpine:alpine /mnt/backup

  ### UPDATE FSTAB
  echo -e "$nfs_server:$nfs_volume /mnt/backup nfs rw,vers=4,rsize=32768,wsize=32768,soft 0 0" | doas tee -a /etc/fstab >/dev/null
fi

if [[ $nfs_media == true ]]; then
  read -p '[REQUIRED] NFS SERVER IP ADDRESS FOR MEDIA: ' nfs_media_address < /dev/tty

  if [[ -z $nfs_media_address ]]; then
    echo "ERROR: NFS SERVER IP ADDRESS FOR MEDIA REQUIRED... Exiting"
    exit 1
  fi

  read -p '[REQUIRED] NFS VOLUME FOR MEDIA: ' nfs_media_volume < /dev/tty

  if [[ -z $nfs_media_volume ]]; then
    echo "ERROR: NFS VOLUME FOR MEDIA REQUIRED... Exiting"
    exit 1
  fi

  ### CREATE MEDIA DIRECTORY
  doas mkdir -p /mnt/media
  doas chown alpine:alpine /mnt/media

  ### UPDATE FSTAB
  echo -e "$nfs_server:$nfs_volume /mnt/media nfs rw,vers=4,rsize=32768,wsize=32768,soft 0 0" | doas tee -a /etc/fstab >/dev/null
fi

### MOUNT
if [[ $nfs_backup == true ]] || [[ $nfs_media == true ]]; then
  doas mount -a
fi
