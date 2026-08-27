# Netscan Bash

Simple network scanner written in pure Bash, for use in offensive security (pentest). Discovers active hosts on the local network via ICMP and scans TCP ports (1-1023) on the found hosts.

## ⚠️ Legal Notice

This project was created for educational and professional purposes (authorized). Use only on networks that you own or have explicit authorization to test. Scanning third-party networks without permission may be a crime, depending on the jurisdiction.

## Motivation

Project developed during pentesting studies, with the goal of assisting pentesting professionals in environments with minimal resources (essential only).

## Features

NTSCN
- Automatic detection of network interface and CIDR range
- Support for /24 and /16 networks
- Discovery of active hosts via ping (ICMP)
- Scanning of known TCP ports (1-1023) via netcat
- Parallel execution for larger networks (/16)

DNSSCAN
- Subdomain scanner (bonus)
- The file subdomain.txt is just for test, you can replace it for a more useful one.

## Requirements

- Bash 4+
- `ping`, `nc` (netcat), `awk`, `ip` (iproute2 packet), dig

## How to use
Tool for bash, so:

chmod +x ntscn.sh
./dntscn.sh
or 
chmod +x dnsscan.sh 
./dnsscan.sh

## Known limitations

- Does not support /8 networks (class A)
- Port scan is a "connect scan" (full TCP), not stealth
- Requires a firewall The target must enable ICMP for host detection.
