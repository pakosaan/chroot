$ # Use Live CD to boot
$ sudo su # Switch to root
$ fdisk -l # Get names of root, boot & EFI partition names. you can also use blkid
$ mount /dev/mapper/fedora_localhost--live-root /mnt  # mount root partition
$ cat /mnt/etc/fedora-release
Fedora
$ lsblk
# Find the partion for EFI and /
# In my case it EFI is in /dev/nvme0n1p1 and / in /dev/nvme0n1p2
$ mount /dev/nvme0n1p1 /mnt/boot/efi  # mount EFI partition

$ # mount the virtual filesystems that the system uses to communicate with processes and devices
$ for dir in /dev /proc /sys /run; do mount --bind $dir /mnt/$dir ; done

$ # enter chroot
$ chroot /mnt

$ # Now you can do all the work e.g. fix grub
$ dnf reinstall grub2-efi shim -y
$ grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg # Regenerate grub2

$ # All things done; now exit from chroot
$ exit

$ # Check BIOS boot details [ Note: this command won't work if you are inside chroot. ]
$ efibootmgr -v
$ # In case you need to create new entry in BIOS
$ efibootmgr -c -d /dev/nvme0n1p1 -p 1 -L Fedora -l '\EFI\fedora\grubx64.efi' # or, shimx64.efi
$ # To delete entry from efibootmgr use: efibootmgr -b <#entry> -B
$ # Copy grubx64.efi from Live USB, if required
$ cp -p /boot/efi/EFI/grubx64.efi /mnt/boot/efi/EFI/fedora 

$ exit
$ # Now you can reboot
