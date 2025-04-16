---
theme: default
class: text-center
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
transition: slide-left
title: "systemd: The Linux System and Service Manager"
mdc: true
---

# systemd
## The Linux System and Service Manager


---

# Agenda

- What is systemd?
- Core Concepts
- Unit Files
- Managing Services
- systemctl Essentials
- Journals and Logging
- Timers
- Socket Activation
- Resource Management
- Security Features
- Advanced Use Cases
- Q&A

---

# What is systemd?

- System and service manager for Linux
- Replacement for SysV init system
- Now the de facto standard on most Linux distributions
- Created by Lennart Poettering and Kay Sievers (2010)
- Focus on parallelization and dependency management

<div class="grid grid-cols-2 gap-x-4 mt-4">
<div>

## Goals
- Faster boot times
- Service dependency handling
- Service supervision
- Consistent interfaces

</div>
<div>

## More than just init
- Service management
- Logging
- Device management
- Network configuration
- And much more...

</div>
</div>

---

# The systemd Ecosystem

<div class="grid grid-cols-3 gap-4">
<div>

## Core Components
- systemd (init)
- systemctl
- journald
- logind
- resolved
- networkd

</div>
<div>

## Tools
- systemctl
- journalctl
- loginctl
- hostnamectl
- timedatectl
- localectl

</div>
<div>

## Unit Types
- service
- socket
- timer
- target
- mount/automount
- path
- slice
- scope

</div>
</div>

---

# systemd Unit Files

- Basic building blocks of systemd
- Plain text configuration files
- Defines services, mounts, timers, etc.
- Located in:
  - `/usr/lib/systemd/system/` (system packages)
  - `/etc/systemd/system/` (system admin)
  - `~/.config/systemd/user/` (user units)

```ini
[Unit]
Description=My Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/myservice
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

---

# Common Unit File Sections

<div class="grid grid-cols-2 gap-4">
<div>

## [Unit] Section
- Description
- Documentation
- Requires, Wants
- After, Before
- Conflicts

</div>
<div>

## [Service] Section
- Type (simple, forking, oneshot)
- ExecStart, ExecStop, ExecReload
- Restart, RestartSec
- Environment
- User, Group

</div>
</div>

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## [Install] Section
- WantedBy
- RequiredBy
- Alias

</div>
<div>

## Other Sections
- [Socket]
- [Mount]
- [Timer]
- [Path]

</div>
</div>

---

# Service Unit Types

<div class="grid grid-cols-2 gap-4">
<div>

## simple (default)
- Main process is the process executed via ExecStart
- Started immediately, considered active when process starts

## forking
- Process spawns a child and then exits
- Service is considered active when parent exits

</div>
<div>

## oneshot
- Process exits before starting follow-up units
- Service is considered active after process exits

## notify
- Like simple but sends notification when ready
- Uses systemd notification protocol

</div>
</div>

---

# Basic systemctl Commands

<div class="grid grid-cols-2 gap-4">
<div>

## Service Management
```bash
# Start a service
systemctl start nginx.service

# Stop a service
systemctl stop nginx.service

# Restart a service
systemctl restart nginx.service

# Reload a service (if supported)
systemctl reload nginx.service
```

</div>
<div>

## Service Status
```bash
# Check status
systemctl status nginx.service

# Check if running
systemctl is-active nginx.service

# Enable at boot
systemctl enable nginx.service

# Disable at boot
systemctl disable nginx.service
```

</div>
</div>

---

# systemctl Status Example

<div class="grid grid-cols-2 gap-4">
<div>

```bash
$ systemctl status sshd.service
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled)
     Active: active (running) since Thu 2025-04-10 13:37:00 UTC; 1h 30min ago
   Main PID: 1286 (sshd)
      Tasks: 1 (limit: 4915)
     Memory: 5.6M
     CGroup: /system.slice/sshd.service
             └─1286 "sshd: /usr/bin/sshd -D [listener] 0 of 10-100 startups"

Apr 10 13:37:00 myserver systemd[1]: Started OpenSSH server daemon.
Apr 10 13:40:15 myserver sshd[1286]: Accepted publickey for user from 192.168.1.100
```

</div>
<div>

### Key Information:
- Unit description
- Whether enabled at boot
- Current state (active, inactive)
- Main process ID (PID)
- Resource usage
- CGroup hierarchy
- Recent log entries

</div>
</div>

---

# Listing Units

<div class="grid grid-cols-2 gap-4">
<div>

## List All Units
```bash
# List all units
systemctl list-units

# List only services
systemctl list-units --type=service

# List all unit files
systemctl list-unit-files

# List failed units
systemctl --failed
```

</div>
<div>

## Unit States
- **loaded/not-loaded**: Unit file parsed
- **active/inactive**: Running or not
- **enabled/disabled**: Starts at boot
- **static**: Cannot be enabled but may be started by another unit
- **masked**: Completely disabled, cannot be started

```bash
# Check unit file state
systemctl is-enabled nginx.service
```

</div>
</div>

---

# Targets

- Replacement for runlevels
- Groups of units to be activated together
- Used for boot process and changing system states

<div class="grid grid-cols-2 gap-4">
<div>

## Common Targets
- `multi-user.target` (text mode)
- `graphical.target` (GUI)
- `rescue.target` (single user mode)
- `emergency.target` (minimal)
- `reboot.target`
- `poweroff.target`

</div>
<div>

## Target Commands
```bash
# View default target
systemctl get-default

# Change default target
systemctl set-default graphical.target

# Switch to a target now
systemctl isolate multi-user.target
```

</div>
</div>

---

# Dependency Management

<div class="grid grid-cols-2 gap-4">
<div>

## Types of Dependencies
- **Requires**: Hard dependency
- **Wants**: Soft dependency
- **After/Before**: Ordering (not dependency)
- **Conflicts**: Cannot run together
- **BindsTo**: Like Requires, but stops if dependency stops

</div>
<div>

## Viewing Dependencies
```bash
# View unit dependencies
systemctl list-dependencies sshd.service

# Show reverse dependencies
systemctl list-dependencies --reverse sshd.service
```

</div>
</div>

---

# Creating a Simple Service

<div class="grid grid-cols-2 gap-4">
<div>

## Example: Web Server Service
```ini
# /etc/systemd/system/mywebapp.service
[Unit]
Description=My Web Application
After=network.target
Wants=mysql.service

[Service]
Type=simple
User=webuser
WorkingDirectory=/var/www/myapp
ExecStart=/usr/bin/node app.js
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

</div>
<div>

## Enable & Start
```bash
# Reload systemd to recognize new unit
systemctl daemon-reload

# Enable and start
systemctl enable --now mywebapp.service

# Check status
systemctl status mywebapp.service
```

</div>
</div>

---

# systemd Journal

- Centralized logging system (journald)
- Collects messages from kernel, services, applications
- Structured, indexed logs with metadata
- Binary format for efficiency
- Logs stored in `/var/log/journal/` or `/run/log/journal/`

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Basic journalctl
```bash
# View all logs
journalctl

# Follow logs in real-time
journalctl -f

# View logs for specific unit
journalctl -u nginx.service
```

</div>
<div>

## Filtering
```bash
# Logs since yesterday
journalctl --since="yesterday"

# Kernel messages only
journalctl -k

# Error priority only
journalctl -p err

# Output formats
journalctl -o json-pretty
```

</div>
</div>

---

# Practical journalctl Examples

<div class="grid grid-cols-2 gap-4">
<div>

## Boot Analysis
```bash
# Current boot logs
journalctl -b 

# Previous boot logs
journalctl -b -1

# Boot time analysis
systemd-analyze
systemd-analyze blame
systemd-analyze critical-chain
```

</div>
<div>

## Troubleshooting
```bash
# Service errors
journalctl -u myservice.service -p err

# Recent logs for a service
journalctl -u myservice.service --since="1 hour ago"

# Follow logs from specific service
journalctl -f -u myservice.service
```

</div>
</div>

---

# systemd Timers

- Alternative to cron jobs
- More flexible scheduling
- Integration with systemd features
- Each timer needs a matching .service file

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Timer Unit Example
```ini
# /etc/systemd/system/backup.timer
[Unit]
Description=Daily backup timer

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true
AccuracySec=1h

[Install]
WantedBy=timers.target
```

</div>
<div>

## Matching Service
```ini
# /etc/systemd/system/backup.service
[Unit]
Description=Daily backup service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-script.sh
User=backup
```

</div>
</div>

---

# Timer Management

<div class="grid grid-cols-2 gap-4">
<div>

## Timer Options
- **OnCalendar**: Time-based (cron-like)
- **OnBootSec**: Time after boot
- **OnUnitActiveSec**: Time after unit activation
- **OnUnitInactiveSec**: Time after unit deactivation
- **Persistent**: Run on next boot if missed
- **RandomizedDelaySec**: Add random delay

</div>
<div>

## Managing Timers
```bash
# List all timers
systemctl list-timers

# Enable and start
systemctl enable --now backup.timer

# Check timer status
systemctl status backup.timer

# Manually trigger service
systemctl start backup.service
```

</div>
</div>

---

# Socket Activation

- Services start on demand when connections arrive
- Reduces boot time and resource usage
- Socket handled by systemd until service starts
- Useful for infrequently used services

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Socket Unit Example
```ini
# /etc/systemd/system/echo.socket
[Unit]
Description=Echo Socket

[Socket]
ListenStream=2000
Accept=yes

[Install]
WantedBy=sockets.target
```

</div>
<div>

## Matching Service
```ini
# /etc/systemd/system/echo@.service
[Unit]
Description=Echo Service

[Service]
Type=simple
ExecStart=/usr/bin/cat
StandardInput=socket
StandardOutput=socket
```

</div>
</div>

---

# Path Units

- Monitor filesystem for changes
- Start services when files/directories change
- Useful for automating workflows
- Reduces need for polling

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Path Unit Example
```ini
# /etc/systemd/system/incoming.path
[Unit]
Description=Monitor incoming directory

[Path]
PathExistsGlob=/var/incoming/*.txt
PathChanged=/var/incoming/

[Install]
WantedBy=multi-user.target
```

</div>
<div>

## Matching Service
```ini
# /etc/systemd/system/incoming.service
[Unit]
Description=Process incoming files

[Service]
Type=oneshot
ExecStart=/usr/local/bin/process-files.sh
```

</div>
</div>

---

# Resource Management with Slices

- Control CPU, memory, IO for service groups
- Hierarchy of cgroups for resource allocation
- Default slices: system.slice, user.slice, machine.slice

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Resource Control in Units
```ini
[Service]
# Memory limits
MemoryMax=1G
MemoryHigh=800M

# CPU limits
CPUQuota=20%
CPUWeight=50

# IO limits
IOWeight=100
IODeviceWeight=/dev/sda 200
```

</div>
<div>

## Runtime Resource Control
```bash
# Set resource limits
systemctl set-property nginx.service CPUQuota=30%

# Create custom slice
cat > /etc/systemd/system/db.slice << EOF
[Slice]
CPUQuota=40%
MemoryMax=4G
EOF

# Place service in slice
systemctl set-property mysql.service Slice=db.slice
```

</div>
</div>

---

# Security Features

<div class="grid grid-cols-3 gap-4">
<div>

## Sandboxing Options
- `PrivateTmp=yes`
- `ProtectHome=yes`
- `ReadOnlyDirectories=`
- `PrivateDevices=yes`
- `NoNewPrivileges=yes`
- `ProtectSystem=strict`

</div>
<div>

## Capabilities
- `CapabilityBoundingSet=`
- `AmbientCapabilities=`
- `RestrictAddressFamilies=`
- `RestrictNamespaces=yes`
- `ProtectKernelTunables=yes`
- `SystemCallFilter=`

</div>
<div>

## Example
```ini
[Service]
# Run as specific user
User=myapp
Group=myapp

# Security restrictions
PrivateTmp=yes
ProtectHome=yes
ProtectSystem=strict
NoNewPrivileges=yes
```

</div>
</div>

---

# networkd and resolved

<div class="grid grid-cols-2 gap-4">
<div>

## systemd-networkd
- Network configuration
- Manages interfaces, routing, bridges
- DHCP client/server

```ini
# /etc/systemd/network/20-wired.network
[Match]
Name=eth0

[Network]
DHCP=yes
```

</div>
<div>

## systemd-resolved
- DNS resolution
- DNS caching
- DNSSEC support

```bash
# View DNS settings
resolvectl status

# Lookup DNS
resolvectl query example.com

# DNS statistics
resolvectl statistics
```

</div>
</div>

---

# User Services

- Services without root privileges
- Each user can manage their own services
- Configuration in `~/.config/systemd/user/`
- Start/stop with `--user` flag

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Example User Service
```ini
# ~/.config/systemd/user/syncthing.service
[Unit]
Description=Syncthing file synchronization

[Service]
ExecStart=/usr/bin/syncthing
Restart=on-failure

[Install]
WantedBy=default.target
```

</div>
<div>

## User Service Management
```bash
# Enable and start user service
systemctl --user enable --now syncthing.service

# Status check
systemctl --user status syncthing.service

# Enable lingering for user
loginctl enable-linger username
```

</div>
</div>

---

# systemd Containers with nspawn

- Lightweight container management
- Integrates with systemd ecosystem
- Simpler than Docker for many use cases
- Share same kernel as host

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Creating Containers
```bash
# Create container from package
sudo debootstrap bookworm /var/lib/machines/debian

# Boot container
sudo systemd-nspawn -b -D /var/lib/machines/debian

# Register as service
sudo machinectl enable debian
```

</div>
<div>

## Managing Containers
```bash
# List containers
machinectl list

# Start container
machinectl start debian

# Shell into container
machinectl shell debian

# Execute command
machinectl -M debian -- systemctl status
```

</div>
</div>

---

# Analyzing Boot Performance

<div class="grid grid-cols-2 gap-4">
<div>

## Analyzing Boot Time
```bash
# Overall boot time
systemd-analyze

# Time per unit
systemd-analyze blame

# Critical chain
systemd-analyze critical-chain

# Plot
systemd-analyze plot > boot.svg
```

</div>
<div>

## Optimizing Boot
- Disable unnecessary services
- Use socket activation
- Use service dependencies properly
- Consider Type=notify for accurate tracking
- Profile and analyze bottlenecks
- ParallelStartupJobs in system.conf

</div>
</div>

---

# Debugging systemd

<div class="grid grid-cols-2 gap-4">
<div>

## Troubleshooting Steps
1. Check service status
   ```bash
   systemctl status service-name.service
   ```
2. Review logs
   ```bash
   journalctl -u service-name.service -b
   ```
3. List dependencies
   ```bash
   systemctl list-dependencies service-name.service
   ```
4. Test start with debug
   ```bash
   systemctl start service-name.service
   ```

</div>
<div>

## Common Issues
- Wrong file permissions
- Missing dependencies
- Incorrect paths in ExecStart
- Timeout settings too low
- Resource limitations
- SELinux/AppArmor constraints

```bash
# Override with drop-in file
systemctl edit myservice.service
```

</div>
</div>

---

# Real-World Example: Multi-Service Application

<div class="grid grid-cols-2 gap-4">
<div>

## Web Application Structure
- Database service
- Cache service
- Web server
- Application
- Background worker

```
app.slice
├── postgres.service
├── redis.service
├── nginx.service
├── app-web.service
└── app-worker.service
```

</div>
<div>

## Deployment
1. Create slice for resource limits
2. Define dependencies with `Requires`/`After`
3. Use socket activation for infrequent services
4. Add security hardening
5. Configure logging rate limits
6. Implement health checks
7. Create helper targets

</div>
</div>

---

# Extending systemd with Generators

- Scripts that dynamically create unit files
- Run during boot before regular units
- Can create units based on system state
- Located in `/usr/lib/systemd/system-generators/`

<div class="grid grid-cols-2 gap-4 mt-4">
<div>

## Use Cases
- Create mount units from fstab
- Dynamically generate units based on hardware
- Configure services based on environment
- Legacy compatibility layers

</div>
<div>

## Example Generator
```bash
#!/bin/bash
# Simple generator to create unit
# based on presence of config file

if [ -f /etc/myapp/config.ini ]; then
  mkdir -p "$1"
  cat > "$1/myapp.service" << EOF
[Unit]
Description=My application

[Service]
ExecStart=/usr/bin/myapp
EOF
fi
```

</div>
</div>

---

# Best Practices

<div class="grid grid-cols-2 gap-4">
<div>

## Design Principles
- Follow single responsibility principle
- Use dependencies correctly
- Adopt security hardening by default
- Implement proper monitoring
- Make services restartable
- Document with comments

</div>
<div>

## Common Mistakes
- Incorrect dependencies (Wants vs. Requires)
- Inappropriate service types
- Missing executable permissions
- Forgetting to run daemon-reload
- Ignoring exit codes
- Poorly configured timeouts
- Not handling signals properly

</div>
</div>

---

# Resources and Learning

<div class="grid grid-cols-2 gap-4">
<div>

## Documentation
- [systemd.io](https://systemd.io/)
- [Systemd man pages](https://www.freedesktop.org/software/systemd/man/)
- [Arch Wiki on systemd](https://wiki.archlinux.org/title/Systemd)
- [Red Hat systemd documentation](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/chap-managing_services_with_systemd)

</div>
<div>

## Tools
- systemd-analyze
- systemd-cat
- systemd-cgls
- systemd-delta
- systemd-notify
- systemd-run
- busctl

</div>
</div>

---

# Wrap Up

<div class="grid grid-cols-3 gap-4">
<div>

## Core Concepts
- Unit files
- systemctl
- Targets
- Journals
- Timers
- Sockets

</div>
<div>

## Advanced Features
- Resource management
- Security sandboxing
- Containers
- User services
- Generators
- Performance analysis

</div>
<div>

## Future Developments
- Improved container support
- Home directory management
- Better integration with cloud
- Extended logging
- Resource accounting

</div>
</div>

## Thank you!

Questions?

---