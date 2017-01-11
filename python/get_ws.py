#!/usr/bin/env python
'''
get_ws.py - Detect web encoding  for provided website
William Farnworth
'''

import requests
import sys


def main():
    url = raw_input("Please enter the URL:  ")

    try:
        response = requests.get(url)
    except:
        print "Please enter valid URL"
        sys.exit(1)
    print response.headers.get('server')
    sys.exit(0)

if __name__ == "__main__":
        main()
