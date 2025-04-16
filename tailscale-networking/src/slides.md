---
theme: default
class: text-center
highlighter: shiki
lineNumbers: false
drawings:
  persist: false
transition: slide-left
title: "Tailscale: Zero-Config VPN for Modern Networks"
mdc: true
---

# Tailscale
## Zero-Config VPN for Modern Networks


---

# Agenda

- What is Tailscale?
- How Tailscale Works
- Tailscale vs Traditional VPNs
- Getting Started
- Key Tailscale Features
- Advanced Use Cases
  - MagicDNS
  - Tailscale SSH
  - Access Controls (ACLs)
  - Subnet Routing
- Self-Hosting with Headscale
- Enterprise Deployment
- Security Considerations
- Integration with Linux Ecosystem
- Demos & Use Cases
- Future of Tailscale

---

# What is Tailscale?

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Mesh-based virtual private network (VPN)
- Built on WireGuard® encryption
- Zero-config secure networking
- Coordination service + client software
- Founded in 2019
- "VPN as a service" approach
- Open source clients, closed control plane (Headscale for self-hosting)

</div>
<div>

## Key Benefits
- No central VPN server needed
- Direct peer-to-peer connections when possible
- Works behind NAT and firewalls
- Single Sign-On (SSO) integration
- Built-in access controls
- Cross-platform support
- Device-level authentication
- No additional infrastructure required

</div>
</div>

---

# How Tailscale Works

<div class="grid grid-cols-2 gap-4">
<div>

## Core Components
- **Tailscale Coordination Server**:
  - Handles authentication
  - Facilitates NAT traversal
  - Distributes access policies
  - Manages key exchange
  - "Control plane" for the network

- **Client Software**:
  - Creates WireGuard interfaces
  - Connects to coordination server
  - Establishes direct connections
  - Handles routing, DNS, etc.

</div>
<div>

## Technical Foundation
- **WireGuard**: Modern, secure VPN protocol
- **DERP**: Designated Encrypted Relay for Packets
  - Fallback relay servers when direct connection impossible
  - End-to-end encrypted even through relay
- **NAT Traversal**:
  - STUN-like techniques
  - Hole punching
  - Path discovery
- **Authentication**:
  - OAuth/OIDC-based
  - JSON Web Tokens
  - Device-based keys

</div>
</div>

---

# Tailscale vs Traditional VPNs

<div class="grid grid-cols-3 gap-4">
<div>

## Traditional VPNs
- Central server required
- All traffic flows through server
- Single point of failure
- Complex configuration
- Firewall/port forwarding needed
- Limited identity integration
- Manual key management
- Gateway-focused security

</div>
<div>

## WireGuard
- Manual key exchange
- Static configuration files
- Requires server setup
- Works with existing servers
- More flexible but complex
- Excellent performance
- Strong security
- No built-in coordination

</div>
<div>

## Tailscale
- No central server needed
- P2P connections when possible
- SSO/identity-based access
- Automatic key rotation
- Works behind NAT
- MagicDNS for simple naming
- ACLs for access control
- Cross-platform clients
- Minimal configuration

</div>
</div>

---

# Getting Started with Tailscale

<div class="grid grid-cols-2 gap-4">
<div>

## Installation
```bash
# Debian/Ubuntu
curl -fsSL https://tailscale.com/install.sh | sh

# RHEL/CentOS/Fedora
dnf install tailscale

# Arch Linux
pacman -S tailscale

# Alpine
apk add tailscale

# macOS
brew install tailscale

# Or download packages from:
# https://tailscale.com/download
```

</div>
<div>

## Basic Setup
```bash
# Start the service
sudo systemctl enable --now tailscaled

# Authenticate and connect
sudo tailscale up

# Authenticate with specific provider
sudo tailscale up --login-server=https://example.com

# Check status
tailscale status

# Get IP address
tailscale ip

# Disconnect
sudo tailscale down
```

</div>
</div>

---

# Key Tailscale Features

<div class="grid grid-cols-3 gap-4">
<div>

## Mesh Connectivity
- Every node can connect to any other
- Direct connections when possible
- DERP relay fallback when needed
- No central bottleneck for traffic
- Efficient routing paths
- Works across network boundaries
- IPv4 and IPv6 support

</div>
<div>

## Identity-Based Networking
- SSO authentication
- Device-based authorization
- Automatic key management
- User-based permissions
- User and group ACLs
- Automatic access revocation
- Tags for role-based access

</div>
<div>

## Zero Configuration
- Auto-discovery of peers
- Automatic key rotation
- Public key infrastructure
- MagicDNS for hostnames
- Coordinate NAT traversal
- Automatic updates
- Stateless configuration

</div>
</div>

---

# MagicDNS

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Automatic DNS for Tailscale nodes
- Simple hostname resolution within tailnet
- Makes IPs human-readable
- No DNS server configuration needed
- Based on device names
- Optional split-DNS with local resolvers

</div>
<div>

## Usage
```bash
# Enable MagicDNS
tailscale up --accept-dns

# Ping a device by name
ping laptop.example.com

# View DNS settings
tailscale status

# Test DNS resolution
nslookup server.example.com

# Custom per-device names:
# Set in Tailscale admin console
```

</div>
</div>

---

# Tailscale SSH

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Built-in SSH server
- Secured by Tailscale authentication
- No need for SSH keys or passwords
- Works across NATs and firewalls
- User-based access control
- Automatic audit logging
- Ideal for server management

</div>
<div>

## Setup and Usage
```bash
# Enable Tailscale SSH server
tailscale up --ssh

# Connect to remote machine
ssh user@hostname

# For older clients, use IP address
ssh user@100.100.100.100

# Check SSH status
tailscale status --ssh

# Disable SSH server
tailscale up --ssh=false
```

</div>
</div>

---

# Access Controls (ACLs)

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Fine-grained access policies
- JSON-based policy language
- Users, groups, and tags
- Control connections between nodes
- Port-level restrictions
- Auto-generated from SSO groups
- Enforced by coordination server
- Version controlled

</div>
<div>

## ACL Example
```json
{
  "acls": [
    // Allow engineers to access dev servers
    {"action": "accept", 
     "users": ["group:engineering"],
     "ports": ["tag:dev:22,80,443"]},
    
    // Allow ops to access all servers
    {"action": "accept", 
     "users": ["group:ops"],
     "ports": ["*:*"]},
     
    // Deny all other access
    {"action": "deny", 
     "users": ["*"],
     "ports": ["*:*"]}
  ],
  "tagOwners": {
    "tag:dev": ["group:devops"]
  }
}
```

</div>
</div>

---

# Subnet Routing

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Expose entire subnets through Tailscale
- Connect to devices not running Tailscale
- Bridge networks securely
- Access local services remotely
- Connect office networks to cloud
- Exit node functionality
- Split tunneling capabilities

</div>
<div>

## Setup
```bash
# Enable subnet routing on gateway
sudo tailscale up --advertise-routes=192.168.1.0/24

# Approve routes in admin console

# Enable route acceptance on clients
sudo tailscale up --accept-routes

# Check available routes
tailscale status --peers

# Test connectivity
ping 192.168.1.100
```

</div>
</div>

---

# Self-Hosting with Headscale

<div class="grid grid-cols-2 gap-4">
<div>

## What is Headscale?
- Open source Tailscale control server
- Compatible with official clients
- Self-hosted alternative
- No dependency on Tailscale service
- Complete control over data
- Free for any number of devices
- Active community-driven project

</div>
<div>

## Deployment
```bash
# Quick setup with Docker
docker run -d \
  --name headscale \
  -p 8080:8080 \
  -v ~/.config/headscale:/etc/headscale \
  headscale/headscale:latest

# Create a user/namespace
headscale namespaces create mycompany

# Register a client
headscale --namespace mycompany \
  preauthkeys create --reusable

# Connect client to Headscale
tailscale up \
  --login-server=https://headscale.example.com \
  --authkey=KEY_HERE
```

</div>
</div>

---

# Enterprise Deployment

<div class="grid grid-cols-2 gap-4">
<div>

## Features for Enterprises
- SSO Integration (Okta, Azure AD, Google)
- Device approval workflows
- Audit logging
- SCIM user provisioning
- IP allocation management
- Split tunneling controls
- Role-based access controls
- Custom DNS configuration
- Tailnet lock (additional security)

</div>
<div>

## Deployment Patterns
- Developer access to cloud resources
- Zero-trust network access
- Remote employee connectivity
- Multi-cloud networking
- IoT device management
- Branch office connectivity
- Secure contractor access
- Kubernetes cluster access
- Database and API access controls

</div>
</div>

---

# Security Considerations

<div class="grid grid-cols-2 gap-4">
<div>

## Security Model
- Device-based authentication
- Principle of least privilege
- End-to-end encryption (WireGuard)
- Short-lived authentication tokens
- Automatic key rotation
- No persistent central access
- Minimal attack surface
- Bug bounty program
- Regular security audits

</div>
<div>

## Best Practices
- Use SSO with 2FA
- Implement strict ACLs
- Enable device approval workflow
- Configure automatic updates
- Leverage tagged devices for roles
- Monitor tailnet activity
- Implement per-app firewall rules
- Consider tailnet lock for high security
- Regularly review access patterns
- Use ephemeral nodes for sensitive tasks

</div>
</div>

---

# Integration with Linux Ecosystem

<div class="grid grid-cols-2 gap-4">
<div>

## Service Integration
- **Kubernetes**: 
  - Tailscale operator for pod connectivity
  - K8s service exposure without ingress
- **Docker**:
  - Container connectivity with tailscale/tailscale
  - Direct container access
- **systemd**:
  - Native service integration
  - Unit dependency management
- **NetworkManager**:
  - DNS integration
  - Connection management

</div>
<div>

## CI/CD & DevOps
- Ephemeral CI runners
- Secure build environments
- Database access for migrations
- Remote debugging
- Secure GitOps workflows
- Dev environment connectivity
- Pre-production environment access
- Runtime debugging
- On-demand test environments

</div>
</div>

---

# Tailscale CLI Deep Dive

<div class="grid grid-cols-2 gap-4">
<div>

## Common Commands
```bash
# Connect with specific settings
tailscale up --hostname=server1 \
  --advertise-tags=tag:server \
  --shields-up

# View network status
tailscale status

# File transfer between nodes
tailscale file cp ~/file.txt server1:~/

# Ping a device
tailscale ping server2

# Network debugging
tailscale netcheck

# View access control info
tailscale acl
```

</div>
<div>

## Advanced Options
```bash
# Use exit node
tailscale up --exit-node=exit-server

# Run as subnet router
tailscale up \
  --advertise-routes=10.0.0.0/24,192.168.1.0/24 \
  --advertise-exit-node

# Use ephemeral node (no saved state)
tailscale up --ephemeral

# Override MTU
tailscale up --override-mtu=1280

# Configure login server
tailscale up \
  --login-server=https://headscale.example.com
```

</div>
</div>

---

# Demo: Setting Up a Private Network

<div class="grid grid-cols-2 gap-4">
<div>

## Scenario
- Connect multiple devices across locations
- Access shared resources
- Secure access to internal services
- No port forwarding or public IPs
- Minimal configuration
- Support for Windows, Linux, macOS

</div>
<div>

## Steps
1. Install Tailscale on all devices
2. Log in with same account
3. Enable subnet routing if needed
4. Configure MagicDNS
5. Set up ACLs for access control
6. Test connectivity between nodes
7. Access services using private Tailscale IPs
8. Enable auto-approval for trusted users

</div>
</div>

---

# Demo: Secure SSH Access

<div class="grid grid-cols-2 gap-4">
<div>

## Scenario
- Remote server management
- No public SSH ports
- No SSH key management
- Identity-based access
- Works across NATs
- Audit logging

</div>
<div>

## Implementation
```bash
# On servers, enable Tailscale SSH
sudo tailscale up --ssh

# In ACL policy, restrict SSH access
{
  "acls": [
    {"action": "accept", 
     "users": ["group:admins"],
     "ports": ["*:22"]},
     
    {"action": "accept", 
     "users": ["group:developers"],
     "ports": ["tag:dev:22"]}
  ]
}

# Connect via SSH
ssh user@hostname
```

</div>
</div>

---

# Use Case: Multi-Cloud Network

<div class="grid grid-cols-2 gap-4">
<div>

## Challenge
- Resources in multiple cloud providers
- Different VPC/VNET configurations
- No direct connectivity
- Complex security groups/firewall rules
- Want unified networking

</div>
<div>

## Tailscale Solution
1. Install Tailscale on instances across clouds
2. Group resources with tags (tag:db, tag:web, etc.)
3. Create ACLs based on resource functions
4. MagicDNS for consistent naming
5. Direct connectivity across clouds
6. No need for VPC peering or VPN gateways
7. Simplified firewall rules
8. Unified access control model

</div>
</div>

---

# Use Case: Zero Trust Access

<div class="grid grid-cols-2 gap-4">
<div>

## Challenge
- Remote workforce
- Need access to internal resources
- Traditional VPN is cumbersome
- Securing third-party access
- Principle of least privilege

</div>
<div>

## Tailscale Solution
1. SSO integration with identity provider
2. Device-based authentication
3. Fine-grained ACLs for access control
4. Automatic key rotation
5. Audit logging for compliance
6. No central VPN bottleneck
7. Per-app access rather than network-wide
8. Device approval workflows
9. Ephemeral access for contractors

</div>
</div>

---

# Advanced Features: Tailnet Lock

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Cryptographic lock for tailnet
- Multi-party authorization
- Prevents central authority access
- Extra layer of security
- Similar to certificate pinning
- Limits coordination server capabilities
- Rotation of node keys still possible
- Clear "break glass" procedures

</div>
<div>

## Implementation
```bash
# Initialize tailnet lock
tailscale lock init

# Each key custodian receives a key

# When changing lock settings
tailscale lock modify

# Requires M-of-N approval from key holders

# Configure automatic rotation
tailscale lock auto-rotation on

# View lock status
tailscale lock status
```

</div>
</div>

---

# Advanced Features: Taildrop

<div class="grid grid-cols-2 gap-4">
<div>

## Overview
- Secure file transfer between devices
- End-to-end encrypted
- Works behind NATs and firewalls
- No size limitations (except disk space)
- More secure than cloud services
- Uses existing Tailscale authentication
- Built-in to Tailscale clients

</div>
<div>

## Usage
```bash
# CLI file transfer
tailscale file cp file.txt remote-host:~/

# Send multiple files
tailscale file cp file1.txt file2.txt remote:~/

# Send directory
tailscale file cp -r ./dir remote:~/backups/

# Receive files (GUI clients)
# Just drag and drop in the Tailscale UI
```

</div>
</div>

---

# Tailscale vs. Similar Solutions

<div class="grid grid-cols-3 gap-4">
<div>

## WireGuard
- Lower level protocol
- Manual configuration
- No coordination service
- Full control over implementation
- Native kernel implementation
- No built-in NAT traversal
- Harder to deploy at scale
- More flexible for custom setups

</div>
<div>

## ZeroTier
- Similar mesh VPN approach
- Centralized controller
- Layer 2 Ethernet virtualization
- More network virtualization focus
- Different security model
- Planetary-scale design
- Less focus on identity integration
- More traditional network design

</div>
<div>

## Cloudflare Zero Trust
- More focus on web application access
- Broader zero trust security suite
- Gateway-based approach for many services
- Identity-aware proxying
- Less peer-to-peer focus
- Web filtering capabilities
- Edge computing integration
- Different pricing model

</div>
</div>

---

# Performance Considerations

<div class="grid grid-cols-2 gap-4">
<div>

## Performance Optimization
- Direct peer connections when possible
- DERP server selection for optimal latency
- Exit node selection for regional traffic
- MTU optimization for different networks
- TCP vs UDP considerations
- QoS marking support
- Bandwidth limitation options
- Management of device resources

</div>
<div>

## Benchmarking
```bash
# Check connection quality
tailscale ping hostname

# Detailed network information
tailscale netcheck

# Speed test between nodes
iperf3 -c tailscale-ip

# Monitor bandwidth usage
tailscale status --tcp

# Check connection paths
tailscale status --peers

# Optimize for high-throughput
tailscale up --override-mtu=1500
```

</div>
</div>

---

# Resources for Learning

<div class="grid grid-cols-2 gap-4">
<div>

## Documentation
- [Tailscale Documentation](https://tailscale.com/docs)
- [Headscale GitHub](https://github.com/juanfont/headscale)
- [Tailscale Blog](https://tailscale.com/blog)
- [WireGuard Documentation](https://www.wireguard.com/papers/)
- [Tailscale GitHub](https://github.com/tailscale)
- [Knowledge Base](https://tailscale.com/kb)
- [Community Forum](https://forum.tailscale.com)

</div>
<div>

## Tutorials and Guides
- [Getting Started Guide](https://tailscale.com/kb/1017/install)
- [Subnet Router Setup](https://tailscale.com/kb/1019/subnets)
- [ACL Configuration](https://tailscale.com/kb/1018/acls)
- [Self-hosting with Headscale](https://github.com/juanfont/headscale/blob/main/docs/running-headscale-container.md)
- [Kubernetes Integration](https://tailscale.com/kb/1185/kubernetes)
- [Docker Integration](https://tailscale.com/kb/1184/docker)
- [Exit Node Configuration](https://tailscale.com/kb/1103/exit-nodes)

</div>
</div>

---

# Wrap Up

<div class="grid grid-cols-3 gap-4">
<div>

## Key Advantages
- Zero configuration
- Built on WireGuard security
- Works across NATs
- Direct P2P connections
- Identity-based networking
- Simple deployment
- Cross-platform support
- Self-hosting option with Headscale

</div>
<div>

## When to Use Tailscale
- Remote team connectivity
- Secure server access
- Multi-cloud networking
- IoT device security
- Home lab remote access
- Zero trust network access
- Developer environments
- Cross-platform file sharing
- Enterprise network segmentation

</div>
<div>

## Getting Started
1. Install tailscale
2. Run tailscale up
3. Authenticate with SSO
4. Connect your devices
5. Configure MagicDNS
6. Set up ACLs
7. Enable SSH access
8. Configure subnet routing if needed
9. Invite team members

</div>
</div>

## Thank you!

Questions?

---