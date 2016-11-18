#!/usr/bin/env python

import requests

response = requests.get('https://www.google.co.uk')
print response.url
print response.encoding
print response.raw
