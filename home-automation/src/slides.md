---
# try also 'default' to start simple
theme: default
# apply any windi css classes to the current slide
class: 'text-center'
# https://sli.dev/custom/highlighters.html
highlighter: shiki
# show line numbers in code blocks
lineNumbers: false
# page transition
transition: slide-left
# enable presenter notes
presenter: true
# use UnoCSS
css: unocss
---


# The Home of a Nerd
## From Anxiety to Automation

---

## What is Home Assistant?

**Open Source Home Automation Platform**
- **Central Hub**: Connects and controls all smart devices
- **Local Control**: Runs on your hardware, not the cloud
- **Device Agnostic**: Works with 3000+ integrations
- **Automation Engine**: Creates rules and logic for your home

---

## Local First Philosophy

**Core Requirement: Everything Must Work Without Internet**

**Why Local First?**
- **Reliability**: Works during internet outages
- **Privacy**: Data stays in your home
- **Speed**: No cloud latency (instant response)
- **Longevity**: No company shutdowns breaking devices
- **Security**: Complete control over your data

---

## Reliability: When Cloud Fails

**Real Examples of Cloud Failures:**

**Amazon Alexa/Echo (2022)**
- 13-hour outage affected millions of smart homes
- Lights, thermostats, locks became unresponsive
- Users locked out of their own homes

**Google Nest (2019)**
- 4-hour outage during winter storm
- Thermostats offline when heating most needed
- No manual override for many affected users

**SmartThings (Multiple incidents)**
- Regular outages affecting automation routines
- Security systems offline during outages
- "Smart" homes became "dumb" homes

---

## When MY Network Fails

**Plot Twist: My Network Goes Down ALL the Time**

**Why My Network Fails:**
- Cat chewed through ethernet cable (again)
- "Upgraded" router firmware, broke everything
- Power outage reset switch to factory defaults
- Tried to "optimize" network, made it worse
- Mystery device flooding network with packets

**The Difference:**
- **Cloud failure**: Call support, wait hours, blame internet
- **My failure**: Grab ethernet cable, fix in 5 minutes
- **Cloud failure**: Tweet angrily at company
- **My failure**: Tweet angrily at myself (more satisfying)

**At least when I break it, I can fix it!**

---

## Privacy: Your Data for Sale

**Real Examples of Privacy Violations:**

**Ring/Amazon (2019-2022)**
- Employees watching customer camera feeds
- Police partnerships accessing footage without warrants
- Data sharing with over 2,000 law enforcement agencies

**Nest/Google (2019)**
- Secret microphones discovered in devices
- Years of undisclosed listening capabilities
- Data integrated into Google's advertising profile

**Wyze (2019)**
- 2.4 million users' data exposed
- Email addresses, WiFi network names, health data
- Cameras accessible to wrong users

---

## Speed: Cloud Latency Kills UX

**Real Examples of Speed Issues:**

**Philips Hue (Cloud Mode)**
- 500ms-2 second delays for simple on/off
- Unacceptable for motion-triggered lighting
- Local bridge: <50ms response time

**SmartThings Routines**
- 3-10 second delays for multi-device scenes
- "Good morning" routine takes 30+ seconds
- Motion sensors triggering lights after you leave

**Voice Assistants**
- "Turn on lights" → 2-3 second cloud round trip
- Faster to walk to physical switch
- Internet hiccups = no response

---

## Longevity: When Companies Quit

**Real Examples of Service Shutdowns:**

**Wink (2020)**
- Free service suddenly required $5/month subscription
- Devices became paperweights overnight
- No local control options provided

**Nest Secure (2020)**
- Google discontinued entire product line
- Security systems with no upgrade path
- Forced migration to different ecosystem

**Insteon (2022)**
- 25-year-old company shut down overnight
- Servers turned off with no warning
- Hub required cloud for basic functions

**Revolv (2016)**
- Google acquired then killed the hub
- $300 devices became "useless bricks"
- No local fallback option

---

## Security: Cloud = Attack Surface

**Real Examples of Security Breaches:**

**Xiaomi Cameras (2020)**
- Users seeing strangers' camera feeds
- Integration bug exposed 1,000+ cameras
- Private homes visible to random users

**Verkada (2021)**
- Hackers accessed 150,000 security cameras
- Hospitals, schools, businesses compromised
- Live feeds exposed for months

**Ubiquiti (2021)**
- Breach potentially exposed user data
- Forced password resets for millions
- Cloud access used to infiltrate networks

**Local First = These Problems Don't Exist**

---

## Communication Protocols

**WiFi + MQTT**
- **WiFi**: Standard network protocol, easy to implement
- **MQTT**: Lightweight messaging for IoT devices
- **Pros**: Cheap, flexible, DIY-friendly (ESPHome)
- **Cons**: Can congest network, power-hungry

**Zigbee**
- **Mesh Network**: Devices relay messages to extend range
- **Low Power**: Battery devices can last years
- **Pros**: Reliable, standardized, good range
- **Cons**: Needs coordinator, can be complex

---

## More Protocols

**Z-Wave**
- **Sub-GHz**: Less interference than 2.4GHz
- **Mesh Network**: Similar to Zigbee
- **Pros**: Very reliable, mature ecosystem
- **Cons**: More expensive, proprietary

**Thread + Matter**
- **Thread**: IPv6-based mesh protocol
- **Matter**: Universal compatibility standard
- **Pros**: Future-proof, interoperable
- **Cons**: Still emerging, limited devices

---

## Protocol Comparison

| Protocol | Range | Power | Mesh | DIY | Cost |
|----------|-------|-------|------|-----|------|
| WiFi/MQTT | Good | High | No | Easy | Low |
| Zigbee | Excellent | Low | Yes | Medium | Medium |
| Z-Wave | Good | Low | Yes | Hard | High |
| Thread | Excellent | Low | Yes | Hard | Medium |

---

## What is ESPHome?

**Firmware Framework for ESP32/ESP8266**
- **YAML Configuration**: Define device behavior simply
- **WiFi/MQTT Based**: Uses your existing network
- **Home Assistant Integration**: Automatic discovery
- **OTA Updates**: Flash wirelessly after initial setup

**Why ESPHome?**
- Turn $5 microcontroller into smart device
- No cloud dependencies
- Completely customizable
- Rock-solid reliability

---

## ESPHome in Practice

**Basic Configuration:**
```yaml
esphome:
  name: bedroom-light
  
esp32:
  board: esp32dev

wifi:
  ssid: "IoT_Network"
  password: "password"

switch:
  - platform: gpio
    pin: GPIO2
    name: "Bedroom Light"
```

**Real Examples:**
- Martin Jerry switches (~$12) flashed with ESPHome
- Emporia Vue 3 power monitor + ESPHome firmware
- Custom sensors for temperature, motion, water leaks

---

## Power Monitoring Options

**Whole-Home Monitoring**
- **Emporia Vue 3** (~$200): 19 inputs, ESPHome flashable
- **IoTaWatt** (~$150): 14 inputs, open source
- **Shelly EM** (~$50): 2-channel, local MQTT support
- **Sense Home** (~$300): AI-powered device detection, cloud-dependent

**Individual Device Monitoring**
- **Sonoff S31** (~$15): Smart plug, Tasmota/ESPHome flashable
- **Shelly Plug S** (~$20): Small form factor, local MQTT
- **DIY Current Clamps** (~$10): CT sensors + ESP32
- **TP-Link Kasa KP115** (~$15): Cloud-based option

**Circuit-Level Options**
- **Shelly 1PM** (~$20): In-wall switch with monitoring, local MQTT
- **Aeotec Z-Wave** (~$40): Z-Wave based solution

---

## Lighting Control Options

**Smart Switches (Replace Wall Switch)**
- **Martin Jerry** (~$12): Tasmota/ESPHome compatible
- **Treatlife** (~$15): Similar to Martin Jerry
- **Shelly 1** (~$15): Fits behind existing switch, local MQTT
- **Inovelli** (~$35): Z-Wave, advanced features
- **Lutron Caseta** (~$50): Reliable, hub + cloud required

**Smart Bulbs**
- **Philips Hue** (~$15-50): Premium, full ecosystem, local via hub
- **Sengled** (~$10): Zigbee, budget-friendly
- **LIFX** (~$20-40): Bright, WiFi-based, cloud-dependent
- **Wyze** (~$8): Very cheap, basic features, cloud-dependent

**Dimmer Options**
- **Shelly Dimmer 2** (~$20): ESPHome compatible
- **Inovelli Z-Wave Dimmer** (~$45): Advanced scenes
- **Lutron Caseta Dimmer** (~$60): Rock solid, cloud-dependent

---

## Water Leak Detection Options

**Zigbee Sensors**
- **Aqara Water Leak Sensor** (~$15): Compact, reliable
- **Samsung SmartThings** (~$20): Good battery life
- **Sonoff SNZB-03** (~$8): Budget option

**WiFi Sensors**
- **Shelly Flood** (~$15): ESPHome compatible
- **DIY ESP32** (~$5): Custom ESPHome solution
- **Govee WiFi** (~$10): App-based alerts, cloud-dependent

**Z-Wave Sensors**
- **Aeotec Water Sensor 6** (~$40): Advanced features
- **Fibaro Flood Sensor** (~$50): Premium option

**Water Shutoff Valves**
- **Zooz Z-Wave Valve** (~$180): Motorized ball valve
- **Shelly Valve** (~$120): WiFi-based control
- **DIY Servo** (~$30): Custom ESPHome solution
- **LeakSmart** (~$200): Complete system, cloud-dependent

---

## Motion Detection Options

**PIR Sensors (Traditional Motion)**
- **Aqara Motion Sensor** (~$15): Zigbee, compact
- **Sonoff SNZB-03** (~$8): Budget Zigbee option
- **Shelly Motion** (~$25): WiFi-based
- **DIY PIR + ESP32** (~$5): Custom ESPHome

**mmWave Sensors (Presence Detection)**
- **TreatLife mmWave** (~$25): ESPHome compatible
- **Aqara FP1** (~$50): Zigbee, room mapping
- **EP1 mmWave** (~$20): ESPHome ready
- **24GHz Radar + ESP32** (~$15): DIY solution

**Hybrid Solutions**
- **Philips Hue Motion** (~$40): PIR + light + temp
- **Aeotec MultiSensor 6** (~$45): Motion + environmental
- **Fibaro Motion** (~$60): Z-Wave, premium features

---

## Climate Control Options

**Smart Thermostats**
- **Ecobee** (~$200): Room sensors, excellent HA integration
- **Honeywell T6** (~$100): Z-Wave, basic features
- **Nest** (~$130): Google ecosystem, learning algorithms, cloud-dependent
- **Wyze Thermostat** (~$50): Budget option, cloud-dependent

**Mini-Split Controllers**
- **DIY IR Blaster** (~$20): ESP32 + IR LED
- **Sensibo** (~$100): Universal IR control, cloud-dependent
- **Cielo Breez** (~$130): WiFi-based, advanced features, cloud-dependent

**HVAC Add-ons**
- **Ecobee Room Sensors** (~$80): Temperature + occupancy
- **DIY Temp Sensors** (~$10): ESP32 + DHT22
- **Nest Temperature Sensors** (~$40): Wireless temp monitoring, cloud-dependent
- **Vent Controllers** (~$100): Keen, Flair for zone control, cloud-dependent

---

## Automation Logic

**PyScript for Complex Logic**
- Custom Python scripts for advanced automations
- Complex conditional logic
- Data processing and analysis
- External API integrations

**Built-in Automations for Simple Tasks**
- Basic triggers and actions
- Time-based schedules
- Simple conditional logic
- Quick to configure and test

---

## System Overview

**Current Setup** (2 months in new house)
- Home Assistant on Lenovo 1L PC
- ~35 ESPHome devices 
- Dual Sonoff coordinators (Zigbee + Thread)
- Emporia Vue 3 power monitoring
- Water leak detection with automated shutoff
- All Martin Jerry switches flashed with ESPHome

---

## Key Features

**Reliable Foundation**
- Network segmentation with VLANs
- ESPHome for local control (no cloud dependencies)
- Physical switches always work
- Automated backups to Romeo server

**Safety & Monitoring**
- Multi-layer water leak protection
- 19-channel power monitoring
- Matrix chat + Twilio voice alerts
- Google Assistant and HA Voice integration

---

## Lessons from the Trenches

**What Actually Works**
- ESPHome devices: Rock solid, rarely fail
- Physical switches always work (family approval ✅)
- Simple automations are most reliable
- Network segmentation prevents single points of failure

**What's Challenging**
- Google Cast devices: "Unreliable" is being kind
- Complex automations: Hard to test edge cases
- Family onboarding: Keep interfaces familiar
- Maintenance: Monthly updates needed

---

## Questions?

**Discussion Topics**
- Specific implementation details
- Device recommendations  
- Network security considerations
- Automation ideas for your home
