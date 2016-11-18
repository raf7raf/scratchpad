#!/usr/bin/env python

import requests

response = requests.head('https://www.google.co.uk')
print response
