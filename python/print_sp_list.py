'''
print_sp_list.py - Print SharePoint Online list to stdout
William Farnworth
'''

import getpass
import requests
import sys
from urlparse import urlparse

spo_auth_url = "https://login.microsoftonline.com/extSTS.srf"

def main():
    # Gather required variables
    user = raw_input("Username:  ")
    password = getpass.getpass()
    list_url = raw_input("URL of SPO list:  ")

    # Load SAML XML file into memory for token request
    with open('spo_soap.xml', 'r') as fin:
        saml = fin.read()
    fin.closed

    # Set username and password in memory
    saml = saml.replace('[username]', user)
    saml = saml.replace('[password]', password)

    # Validate URL and extract SharePoint Online login URL
    url = urlparse(list_url)

    if url.scheme is not "https" or url.netloc is None:
        print "Invalid or malformed URL provided.  Aborting"
        sys.exit(1)

    # Retrieve token from SharePoint Online Security Token Service
    headers = {'Content-Type': 'application/xml'}
    token = requests.post(spo_auth_url, data=saml, headers=headers)
    print token.text
    print token.status_code

if __name__ == "__main__":
        main()
