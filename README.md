# DNAC Network Device Config Archiver POC

_Simple utility to archive network device configurations from DNA Center_

---

This utility is sample code, provided as a demonstration of how to archive device configurations with the DNA Center API.


## Features

* Downloads the device configuration for all devices in DNA Center and saves it to a local directory.


## Solution Components

### Cisco Products / Services

* Cisco DNA Center


## Usage

Using the utility is simple:
* Configure the *dnac_config.py* to match your DNA Center details
* Then run the utility:
```
python dnac_network_device_config_archiver_poc.py
```


## Installation

Installation is straight forward:  

1. Clone the repo:
```
git clone https://github.com/CiscoSE/dnac_network_device_config_archiver_poc
```

2. Make a [virtual environment](https://packaging.python.org/guides/installing-using-pip-and-virtual-environments/) (**optional**)  

3. Install the requirements with Python's package manager:
```
pip install -r requirements.txt
```