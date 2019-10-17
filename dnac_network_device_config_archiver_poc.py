#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
Python example script showing proper use of the Cisco Sample Code header.

Copyright (c) 2019 Cisco and/or its affiliates.

This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at

               https://developer.cisco.com/docs/licenses

All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.
"""


__author__ = "Sam Byers <sabyers@cisco.com>"
__contributors__ = []
__copyright__ = "Copyright (c) 2019 Cisco and/or its affiliates."
__license__ = "Cisco Sample Code License, Version 1.1"


import requests
from requests.auth import HTTPBasicAuth
from dnac_config import DNAC, DNAC_PORT, DNAC_USER, DNAC_PASSWORD
import json
import os
from datetime import datetime


class dnac:

    def __init__(self, base_url, username, password, token_timeout=3600, port=443):
        self.base_url = base_url
        self.port = port
        self.username = username
        self.password = password
        self.token = None
        self.token_timeout = token_timeout # Not implemented


    def _get(self, api_endpoint):
        
        url = 'https://{}{}'.format(self.base_url, api_endpoint)
        headers = {
            'content-type': "application/json",
            'x-auth-token': self.token
            }

        try:
            resp = requests.get(url, headers=headers, verify=False)
            return resp
        except(ConnectionError):
            print("Missing or invalid connection argument (url, API Key, etc.).")
            raise SystemExit


    def connect(self):
        '''
        Connects and authenticates to DNAC and gets a corresponding token
        Takes username and password for basic auth
        Returns authentication token to use with requests to DNAC's API
        '''

        url = 'https://{}/dna/system/api/v1/auth/token'.format(self.base_url)
        try:
            resp = requests.post(url, auth=HTTPBasicAuth(self.username, self.password), verify=False)
            self.token = resp.json()['Token']
            return self.token
        except: # Not good, but this is just a poc
            print('\n\nFailed to connect and authenticate to DNAC. Check reachability, DNS, and/or username and password.\n\n')


    def get_device_list(self):
        '''
        Retrieves all devices in DNAC
        Returns list of directionaries containing devices with attributes
        '''

        api_endpoint = '/dna/intent/api/v1/network-device'
        resp = self._get(api_endpoint)
        device_list = resp.json()
        return device_list['response'] # Take off outer response dictionary and return list


    def get_all_device_configs(self):
        '''
        Restrieves all device configs from DNAC
        Returns list of dictionaries containing device IDs and configs
        '''

        api_endpoint = '/dna/intent/api/v1/network-device/config'
        resp = self._get(api_endpoint)
        device_config_list = resp.json()
        return device_config_list['response'] # Take off outer response dictionary and return list


    def get_device_config(self, network_device_id):
        '''
        Restrieves device configs from DNAC based on provided network device ID
        Takes a network device ID
        Returns device configuration as a string
        '''

        api_endpoint = '/dna/intent/api/v1/network-device/{}/config'.format(network_device_id)
        resp = self._get(api_endpoint)
        device_config = resp.json()

        if 'response' in device_config.keys():
            return device_config['response'] # Take off outer response dictionary and return string


if __name__ == '__main__':

    dnac_conn = dnac(base_url=DNAC, username=DNAC_USER, password=DNAC_PASSWORD)
    
    dnac_conn.connect()
    
    device_list = dnac_conn.get_device_list()

    output_path = './DNAC_Config_Archive/{}/'.format(datetime.now())
    os.makedirs(output_path)
    
    if os.path.exists(output_path):
        device_output_dict = {}

        for device in device_list:
            device_config = dnac_conn.get_device_config(device['id'])
            device_hostname = device['hostname']
            device_output_dict[device_hostname] = device_config

        for device, config in device_output_dict.items():
            if config:
                with open(output_path + device, 'w') as f:
                    f.write(config)
                print('Saved configuration for {}.'.format(device))