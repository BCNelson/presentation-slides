---
theme: default
class: text-center
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
transition: slide-left
title: "WireGuard: Modern VPN for the Linux Ecosystem"
mdc: true
---

# WireGuard
## Modern VPN for the Linux Ecosystem

<div class="absolute bottom-10">
<span class="opacity-50">Linux Conference 2025</span>
</div>

---

# Agenda

- Introduction to WireGuard
- How VPNs work (brief refresher)
- WireGuard vs. traditional VPNs
- Core concepts and architecture
- Setting up WireGuard
- Advanced configurations
- Performance tuning
- Security considerations
- Enterprise use cases
- Mobile and cross-platform usage
- Tools and ecosystem
- Future developments

---

# What is WireGuard?

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Modern, secure VPN protocol
- Integrated in Linux kernel since 5.6
- Created by Jason Donenfeld (2016)
- Simple, fast, and secure by design
- Only ~4,000 lines of code
- "The most secure, easiest to use, and simplest VPN solution"

</div>
<div>

## Design Principles
- Minimal attack surface
- Cryptographically sound
- Simple to deploy and configure
- High performance
- "Secure by default"
- No knobs to tune incorrectly
- Minimal trusted code base

</div>
</div>

---

# How VPNs Work: Refresher

<div class="grid grid-cols-2 gap-4">
<div>

## VPN Basics
- Create encrypted tunnel between endpoints
- Extension of private network across public internet
- All traffic flows through encrypted tunnel
- Appear as if you're on the remote network
- Protect against eavesdropping on untrusted networks

</div>
<div>

## Common VPN Use Cases
- Secure remote access to company networks
- Bypass geolocation restrictions
- Improve privacy from ISPs
- Connect branch offices securely
- Secure access to cloud resources
- Hosting game servers or homelab access

</div>
</div>

---

# WireGuard vs. Traditional VPNs

<div class="grid grid-cols-3 gap-4">
<div>

## OpenVPN
- Complex (400K+ lines of code)
- SSL/TLS based
- Flexible but complicated
- CPU-intensive
- Multiple authentication options
- Slower connection establishment

</div>
<div>

## IPsec
- Complex protocol suite
- Hard to configure correctly
- NAT traversal issues
- Well-established in enterprise
- Many implementation variants
- Large attack surface

</div>
<div>

## WireGuard
- Minimal (4K lines of code)
- Modern cryptography
- In-kernel implementation
- Fast connection setup
- Simple configuration
- Better performance
- "Invisible" when not in use

</div>
</div>

---

# Core Concepts

<div class="grid grid-cols-2 gap-4">
<div>

## Interface-Based
- Appears as network interface (like wg0)
- Configured like other network interfaces
- Uses UDP (default port 51820)
- Stateless design (no "connections")
- No handshakes needed to establish link

</div>
<div>

## Cryptography
- Noise protocol framework
- Curve25519 for key exchange
- ChaCha20 for encryption
- Poly1305 for authentication
- BLAKE2s for hashing
- Perfect forward secrecy
- Identity hiding (like TLS 1.3)

</div>
</div>

---

# WireGuard Components

<div class="grid grid-cols-2 gap-4">
<div>

## Key Components
- Public/private key pairs
  - Like SSH keys
  - Generate once, use everywhere
- Interface configuration
  - Local settings
  - IP address assignments
- Peer configuration
  - Remote endpoints
  - Allowed IPs
  - Pre-shared keys (optional)

</div>
<div>

## Terminology
- **Interface**: Local WireGuard setup
- **Peer**: Remote WireGuard endpoint
- **Endpoint**: IP:port of a peer
- **Allowed IPs**: Routes for traffic
- **PresharedKey**: Additional security
- **PersistentKeepalive**: NAT traversal helper

</div>
</div>

---

# Setting Up WireGuard: Prerequisites

<div class="grid grid-cols-2 gap-4">
<div>

## Installation
```bash
# Debian/Ubuntu
sudo apt install wireguard

# RHEL/CentOS/Fedora
sudo dnf install wireguard-tools

# Arch Linux
sudo pacman -S wireguard-tools

# Alpine
sudo apk add wireguard-tools
```

</div>
<div>

## Generate Key Pair
```bash
# Create private key
wg genkey > privatekey

# Derive public key from private key
cat privatekey | wg pubkey > publickey

# Or all at once
wg genkey | tee privatekey | wg pubkey > publickey

# Optionally generate preshared key
wg genpsk > presharedkey
```

</div>
</div>

---

# Basic Configuration: Server

<div class="grid grid-cols-2 gap-4">
<div>

## Interface Configuration
```ini
# /etc/wireguard/wg0.conf
[Interface]
PrivateKey = SERVER_PRIVATE_KEY
Address = 10.0.0.1/24
ListenPort = 51820
SaveConfig = true

# Optional but recommended
PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE
```

</div>
<div>

## Client/Peer Configuration
```ini
# Add to server's wg0.conf
[Peer]
PublicKey = CLIENT_PUBLIC_KEY
AllowedIPs = 10.0.0.2/32
```

</div>
</div>

---

# Basic Configuration: Client

<div class="grid grid-cols-2 gap-4">
<div>

## Client Interface
```ini
# /etc/wireguard/wg0.conf
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24
```

</div>
<div>

## Server/Peer Configuration
```ini
# Add to client's wg0.conf
[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = server.example.com:51820
AllowedIPs = 0.0.0.0/0, ::/0
PersistentKeepalive = 25
```

</div>
</div>

---

# Starting and Managing WireGuard

<div class="grid grid-cols-2 gap-4">
<div>

## Manual CLI Control
```bash
# Start interface
sudo wg-quick up wg0

# Stop interface
sudo wg-quick down wg0

# Check status
sudo wg show

# Detailed status with stats
sudo wg show wg0

# Change configuration on the fly
sudo wg set wg0 peer PUBLIC_KEY endpoint new.endpoint.com:51820
```

</div>
<div>

## Systemd Integration
```bash
# Enable at boot
sudo systemctl enable wg-quick@wg0

# Start service
sudo systemctl start wg-quick@wg0

# Check service status
sudo systemctl status wg-quick@wg0

# Restart after config changes
sudo systemctl restart wg-quick@wg0
```

</div>
</div>

---

# Understanding "AllowedIPs"

<div class="grid grid-cols-2 gap-4">
<div>

## What AllowedIPs Does
- Acts as both **ACL** and **routing table**
- Restricts which source IPs peer can send
- Determines which destinations go to this peer
- Like a bidirectional route/firewall rule
- Controls **split tunneling**

</div>
<div>

## Common Configurations
- `10.0.0.2/32`: Only this IP (client on server)
- `0.0.0.0/0, ::/0`: All traffic (server on client)
- `10.0.0.0/24`: Only VPN subnet
- `192.168.1.0/24, 10.0.0.0/24`: Selected networks
- `0.0.0.0/0, !192.168.1.0/24`: All except local LAN

</div>
</div>

---

# Advanced Configuration: Split Tunneling

<div class="grid grid-cols-2 gap-4">
<div>

## Server Config
```ini
# /etc/wireguard/wg0.conf on server
[Interface]
PrivateKey = SERVER_PRIVATE_KEY
Address = 10.0.0.1/24
ListenPort = 51820

[Peer]
PublicKey = CLIENT_PUBLIC_KEY
AllowedIPs = 10.0.0.2/32
```

</div>
<div>

## Client Config for Split Tunnel
```ini
# /etc/wireguard/wg0.conf on client
[Interface]
PrivateKey = CLIENT_PRIVATE_KEY
Address = 10.0.0.2/24

[Peer]
PublicKey = SERVER_PUBLIC_KEY
Endpoint = server.example.com:51820
# Only route internal networks via VPN
AllowedIPs = 10.0.0.0/24, 192.168.10.0/24
PersistentKeepalive = 25
```

</div>
</div>

---

# Advanced Configuration: Full Mesh

<div class="grid grid-cols-2 gap-x-4">
<div>

## Full Mesh VPN
- Each node connects directly to others
- No central server bottleneck
- Better performance for node-to-node traffic
- More complex setup
- Each node needs a peer section for every other node
- Good for site-to-site connections

</div>
<div>

![Mesh Network](https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/NetworkTopology-Mesh.png/440px-NetworkTopology-Mesh.png)

</div>
</div>

---

# Advanced Configuration: NAT Traversal

<div class="grid grid-cols-2 gap-4">
<div>

## Challenges
- Both peers behind NAT
- No direct connectivity
- Dynamic IP addresses
- Firewall restrictions

</div>
<div>

## Solutions
- **PersistentKeepalive**: Sends packets every n seconds to maintain NAT mapping
- **Fixed endpoint**: One peer with public IP/port
- **Endpoint updates**: WireGuard adjusts on the fly
- **Port forwarding**: Open port 51820/UDP on one end
- **Third-party solutions**: Headscale, Tailscale

```ini
[Peer]
PublicKey = PEER_PUBLIC_KEY
Endpoint = peer.example.com:51820
PersistentKeepalive = 25
```

</div>
</div>

---

# Advanced Config: Multi-Tunnel Configuration

<div class="grid grid-cols-2 gap-4">
<div>

## Multiple Interfaces
```ini
# /etc/wireguard/work.conf
[Interface]
PrivateKey = WORK_PRIVATE_KEY
Address = 10.100.0.2/24

[Peer]
PublicKey = WORK_SERVER_PUBLIC_KEY
Endpoint = work.example.com:51820
AllowedIPs = 10.100.0.0/24, 192.168.10.0/24
```

```ini
# /etc/wireguard/personal.conf
[Interface]
PrivateKey = PERSONAL_PRIVATE_KEY
Address = 10.200.0.2/24

[Peer]
PublicKey = PERSONAL_SERVER_PUBLIC_KEY
Endpoint = personal.example.com:51820
AllowedIPs = 10.200.0.0/24
```

</div>
<div>

## Usage and Management
```bash
# Start specific tunnel
sudo wg-quick up work
sudo wg-quick up personal

# Check active interfaces
sudo wg show

# Specific route prioritization
# Lower metric = higher priority
sudo ip route add 192.168.10.0/24 \
  dev work metric 100
```

</div>
</div>

---

# Performance Optimization

<div class="grid grid-cols-2 gap-4">
<div>

## Kernel Parameter Tuning
```bash
# Increase UDP buffer sizes
sysctl -w net.core.rmem_max=2500000
sysctl -w net.core.wmem_max=2500000

# TCP Receive window auto-tuning
sysctl -w net.ipv4.tcp_rmem="4096 87380 16777216"
sysctl -w net.ipv4.tcp_wmem="4096 65536 16777216"

# Make permanent
cat > /etc/sysctl.d/99-wireguard.conf << EOF
net.core.rmem_max=2500000
net.core.wmem_max=2500000
net.ipv4.tcp_rmem="4096 87380 16777216"
net.ipv4.tcp_wmem="4096 65536 16777216"
EOF
```

</div>
<div>

## WireGuard-Specific Options
- MTU optimization
  ```ini
  # Add to [Interface] section
  MTU = 1420
  ```

- Multithreaded cryptography
  ```bash
  sudo modprobe wireguard
  echo options wireguard parallel_workers=4 | \
    sudo tee /etc/modprobe.d/wireguard.conf
  ```

- Fwmark for policy-based routing
  ```ini
  # Add to [Interface] section
  FwMark = 51820
  ```

</div>
</div>

---

# WireGuard Security Deep Dive

<div class="grid grid-cols-2 gap-4">
<div>

## Cryptographic Foundation
- Based on Noise Protocol Framework
  - Noise_IK handshake pattern
  - Streamlined 1-RTT handshake
- Public key crypto:
  - Curve25519 for ECDH
  - Edwards25519 for signatures
- Symmetric crypto:
  - ChaCha20 for encryption
  - Poly1305 for authentication (AEAD)
- Hash function:
  - BLAKE2s (faster than SHA)

</div>
<div>

## Security Properties
- Perfect forward secrecy
- Identity hiding (resistant to scanning)
- Key rotation every few minutes
- DoS mitigation (cookie mechanism)
- No unauthenticated packets ever processed
- No downgrade attacks possible
- Simple design means fewer bugs
- Formally verified key exchange
- Minimal state tracking

</div>
</div>

---

# Security Best Practices

<div class="grid grid-cols-2 gap-4">
<div>

## Configuration Security
- Use preshared keys for additional security
  ```ini
  [Peer]
  PublicKey = PEER_PUBLIC_KEY
  PresharedKey = PRESHARED_KEY
  ```
- Restrictive AllowedIPs (principle of least privilege)
- Keep private keys secure (0600 permissions)
- Use unique keys for each client
- Enable fail-closed firewall rules
- Regular key rotation for sensitive deployments

</div>
<div>

## System Security
- Run minimal services on VPN servers
- Keep kernel and WireGuard up-to-date
- Disable logging of sensitive data
- Use unpredictable IP range (not 10.0.0.0/24)
- Consider port randomization (not 51820)
- Implement rate limiting for authentication attempts
- Monitor for unusual connection patterns
- Consider isolated network namespace for WireGuard

</div>
</div>

---

# Enterprise Use Cases

<div class="grid grid-cols-2 gap-4">
<div>

## Site-to-Site Connectivity
- Connect multiple office locations
- Connect to cloud environments (AWS, Azure, GCP)
- Disaster recovery sites
- Secure supplier/partner connections
- IoT device fleet management

</div>
<div>

## Remote Access VPN
- Work from home access
- Zero-trust network access
- Tiered access controls
- Contractor secure access
- DevOps infrastructure access
- "Road warrior" configurations

</div>
</div>

---

# Enterprise Deployment Considerations

<div class="grid grid-cols-2 gap-4">
<div>

## Scale & High Availability
- Load balancing with consistent hashing
- Active-passive failover
- BGP for redundant routing
- Anycast for global distribution
- Multiple entry points with consistent configs
- Automated deployment and configuration

</div>
<div>

## Integration
- User directory (LDAP/AD) integration
- Certificate-based authentication
- Single Sign-On (SSO) workflows
- Multi-factor authentication
- Configuration management (Ansible, Puppet, etc.)
- Monitoring integration (Prometheus, Grafana)
- IDS/IPS integration

</div>
</div>

---

# Ecosystem Tools

<div class="grid grid-cols-3 gap-4">
<div>

## Management
- **wg-quick**: Simplified setup
- **NetworkManager**: Desktop integration
- **systemd-networkd**: Native integration
- **WireGuard UI**: Web interface
- **Firezone**: Full stack solution
- **Headscale**: Self-hosted Tailscale

</div>
<div>

## Automation
- **wg-meshconf**: Generate mesh configs
- **wg-gen-web**: Web-based config generator
- **wireguard-manager**: Admin portal
- **Ansible roles**: Infrastructure as code
- **Terraform providers**: Cloud automation
- **Docker containers**: Isolated deployments

</div>
<div>

## Monitoring
- **Prometheus exporter**: Metrics collection
- **wg-dashboard**: Visual interface
- **Grafana dashboards**: Visualization
- **SNMP integration**: Enterprise monitoring
- **ELK stack**: Log analysis
- **NetFlow/sFlow**: Traffic analysis

</div>
</div>

---

# Mobile and Cross-Platform Usage

<div class="grid grid-cols-2 gap-4">
<div>

## Official Apps
- **Android**: Official WireGuard app
- **iOS**: Official WireGuard app
- **macOS**: Official app + CLI tools
- **Windows**: Official app + CLI tools
- **Linux**: Native kernel + tools

Cross-platform configuration format makes migration easy.

</div>
<div>

## Integration with Mobile Apps
- QR code based setup
- On-demand activation
- Per-app VPN settings (Android)
- Network extension (iOS)
- Location-based activation
- Battery optimizations
- Profile sharing

</div>
</div>

---

# Setting Up WireGuard on Mobile

<div class="grid grid-cols-2 gap-4">
<div>

## App Install & Setup
1. Install from App/Play Store
2. Create new empty tunnel
3. Import configuration
   - Scan QR code
   - Import from file
   - Manual entry
4. Activate tunnel

</div>
<div>

## QR Code Generation
```bash
# On server, generate client config with QR code
qrencode -t ansiutf8 < client-mobile.conf
```

![WireGuard QR Code](https://www.wireguard.com/img/qr-code.svg)

</div>
</div>

---

# Real-World WireGuard Use Cases

<div class="grid grid-cols-2 gap-4">
<div>

## Home Lab
- Access home services securely
- Smart home device connections
- Secure access to NAS/media servers
- Game server access
- Router with WireGuard built-in
- IoT device isolation

</div>
<div>

## Cloud Deployments
- Connect Kubernetes clusters
- Secure database access
- Private API endpoints
- Multi-cloud networking
- Serverless function access
- Secure bastion host access

</div>
</div>

---

# Troubleshooting Tips

<div class="grid grid-cols-2 gap-4">
<div>

## Common Issues
- Incorrect AllowedIPs configuration
- Firewall blocking UDP port
- Incorrect routing
- NAT issues
- Interface MTU problems
- DNS resolution failures
- Key mismatch
- Clock skew

</div>
<div>

## Diagnosis Commands
```bash
# Check interface status
sudo wg show

# Check logs
sudo journalctl -xeu wg-quick@wg0

# Test connectivity
ping 10.0.0.1

# Check routing
ip route get 10.0.0.1

# Debug packet flow
sudo tcpdump -i wg0

# Check firewall
sudo iptables -L -v
```

</div>
</div>

---

# Future of WireGuard

<div class="grid grid-cols-2 gap-4">
<div>

## Current Development
- IPv6 improvements
- Mobile integration enhancements
- Enterprise management tools
- Container network integrations
- Performance optimizations
- Wider OS kernel adoption
- Streamlined user provisioning tools

</div>
<div>

## Ecosystem Growth
- Router/firewall integration
- IoT device support
- Service mesh integration
- Zero-trust frameworks
- Cloud-native networking
- Software-defined perimeter
- Managed service offerings
- Regulatory compliance tooling

</div>
</div>

---

# Comparison with Similar Solutions

<div class="grid grid-cols-3 gap-4">
<div>

## Tailscale/Headscale
- Built on WireGuard
- Easier NAT traversal
- Centralized management
- Automatic key distribution
- Access controls
- MagicDNS for name resolution
- No self-hosted server needed

</div>
<div>

## ZeroTier
- Software-defined networking
- Similar easy-of-use goals
- P2P when possible
- Centralized controller
- Global supernodes for relay
- Planetary scale design
- Virtual L2 Ethernet

</div>
<div>

## Nebula
- Created by Slack
- Similar crypto foundations
- Built-in certificate authority
- More structured PKI model
- Focus on authorization
- Lighthouse nodes for discovery
- More complex, more features

</div>
</div>

---

# Resources for Learning

<div class="grid grid-cols-2 gap-4">
<div>

## Documentation
- [WireGuard Website](https://www.wireguard.com/)
- [WireGuard Manual Page](https://git.zx2c4.com/wireguard-tools/about/src/man/wg.8)
- [WireGuard Quick Start](https://www.wireguard.com/quickstart/)
- [WireGuard Protocol Paper](https://www.wireguard.com/papers/wireguard.pdf)
- [Arch Wiki on WireGuard](https://wiki.archlinux.org/title/WireGuard)
- [Digital Ocean Guide](https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04)

</div>
<div>

## Community & Support
- IRC: #wireguard on Libera.Chat
- r/WireGuard subreddit
- GitHub: wireguard-linux
- Mailing list: wireguard@lists.zx2c4.com
- Stack Exchange tags
- Third-party documentation
- YouTube tutorials

</div>
</div>

---

# Wrap Up

<div class="grid grid-cols-3 gap-4">
<div>

## Key Advantages
- Simple configuration
- Strong security by default
- Excellent performance
- Minimal attack surface
- Cross-platform support
- Kernel integration
- Modern cryptography
- Stateless design

</div>
<div>

## When to Use WireGuard
- Remote access VPN
- Site-to-site connections
- Cloud resource access
- Home lab security
- IoT device networking
- Privacy protection
- Mobile device security
- Multi-site networking

</div>
<div>

## Getting Started
1. Install wireguard-tools
2. Generate key pairs
3. Create basic config
4. Start with wg-quick
5. Test connectivity
6. Enable with systemd
7. Add more peers as needed
8. Explore advanced features

</div>
</div>

## Thank you!

Questions?

---