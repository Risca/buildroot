#!/bin/sh

# remove unnecessary files
rm -rf "$1/etc/profile.d"
rm -f "$1/etc/protocols"
rm -f "$1/etc/services"
rm -f "$1/usr/sbin/vmcore-dmesg"
