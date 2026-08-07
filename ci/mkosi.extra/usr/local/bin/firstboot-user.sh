#!/bin/bash

DONE_FLAG=/var/lib/firstboot-user-done

[ -f "$DONE_FLAG" ] && exit 0

SAVED_PRINTK=$(cat /proc/sys/kernel/printk)
echo 3 > /proc/sys/kernel/printk
kill -SIGRTMIN+21 1
trap 'echo "$SAVED_PRINTK" > /proc/sys/kernel/printk; kill -SIGRTMIN+20 1' EXIT
trap 'echo "$SAVED_PRINTK" > /proc/sys/kernel/printk; kill -SIGRTMIN+20 1; exit 130' INT TERM

echo
echo "======== First Boot Setup ========"
echo "Create your user account."
echo

while true; do
    read -r -p "Username: " USERNAME
    if [ -z "$USERNAME" ]; then
        echo "Username cannot be empty."
    elif ! echo "$USERNAME" | grep -qE '^[a-z_][a-z0-9_-]{0,31}$'; then
        echo "Invalid username. Use lowercase letters, digits, underscore, or hyphen; must start with a letter or underscore."
    else
        break
    fi
done

if id "$USERNAME" &>/dev/null; then
    echo "User '${USERNAME}' already exists (resuming from partial setup)."
elif ! useradd -m -G wheel "$USERNAME"; then
    echo "ERROR: Failed to create user '${USERNAME}'."
    exit 1
fi

echo "Set password for ${USERNAME}:"
PASSWD_TRIES=0
until passwd "$USERNAME"; do
    PASSWD_TRIES=$((PASSWD_TRIES + 1))
    if [ "$PASSWD_TRIES" -ge 5 ]; then
        echo "Too many failures. Removing partial user and aborting."
        userdel -r "$USERNAME" 2>/dev/null
        exit 1
    fi
    echo "Please try again ($((5 - PASSWD_TRIES)) attempts remaining)."
done

touch "$DONE_FLAG"

echo
echo "User '${USERNAME}' created."
echo -n "Waiting for network..."
IP=""
for i in $(seq 1 15); do
    IP=$(ip -4 addr show 2>/dev/null | grep -o 'inet [0-9.]*' | grep -v '127\.0\.0\.1' | cut -d' ' -f2 | head -1)
    [ -n "$IP" ] && break
    sleep 1
    echo -n "."
done
echo
[ -n "$IP" ] && echo "SSH: ssh ${USERNAME}@${IP}" || echo "No IP yet — check your router/DHCP server for the board IP."
echo
sleep 2

