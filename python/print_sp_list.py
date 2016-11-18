'''
print_sp_list.py - Print SharePoint Online list to stdout
William Farnworth
'''

import argparse
import getpass
import requests
import sys
from urlparse import urlparse

spo_login_url = "https://satelliteinfo.sharepoint.com"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("user", help="SharePoint Online username")
    parser.add_argument("list_url", help="Full URL to the list")
    args = parser.parse_args()

    # Validate URL and extract SharePoint Online login URL
    url = urlparse(args.list_url)

    if url.netloc is None:
        print "Invalid or malformed URL provided.  Aborting"
        sys.exit(1)

    # Authenticate with SharePoint and store token
    session = requests.Session()
    token = session.get(spo_login_url, auth=(args.user, getpass.getpass()))

    if token.status_code != 200:
        sys.exit(1)

    print token.text
    # Attempt to connect to list
    #sp_list = requests.get(args.list_url)
    #print sp_list.status_code

if __name__ == "__main__":
        main()
