#!/usr/bin/env python
'''
Pickle various types of data
'''

import cPickle as pickle

def main():
    Types = { "AnInt": 42, \
            "AFloat": 3.14159265359, \
            "AComplex": 126j, \
            "AChar": 'x', \
            "AString": "The knights that say nee", \
            "AList": "[ 'Wolverine', 'Dr X', 'Cyclops', 'Storm', 'Toad' ]", \
            "ATuple": "( 'Mario', 'Luigi', 'Bowser', 'Princess Toadstool' )", \
            "ADict": "{ 'Rock': 'Draw', 'Paper': 'Win', 'Scissors': 'Lose' }" \
             }
    pickle_file_binary = open("/tmp/types.pickled.bin", "wb")
    print "Pickling data types into binary file"
    pickle.dump(Types, pickle_file_binary, -1)

    pickle_file_normal = open("/tmp/types.pickled", "wb")
    print "Pickling data types into regular file"
    pickle.dump(Types, pickle_file_normal, 0)

if __name__ == "__main__":
        main()
