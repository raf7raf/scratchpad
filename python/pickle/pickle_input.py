#!/usr/bin/env python
'''
Pickler test file
'''

import pickle

def main():
    favourite_number = raw_input("Please enter your favourite number: ")
    print 'Pickling to file /tmp/number.pickle'
    pickle.dump(favourite_number, open("/tmp/number.pickle", "wb"))

    print 'Extracting number from file'
    unpickled_number = pickle.load(open("/tmp/number.pickle", "rb"))
    print 'Your favourite number is %s' % unpickled_number

if __name__ == "__main__":
        main()
