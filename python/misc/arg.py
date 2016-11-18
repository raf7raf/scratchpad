#!/usr/bin/env python
'''
argparse.py - Testing argparse module
William Farnworth - 2016
'''

import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("gerbil", help="Name your furry friend")
    parser.add_argument("--age", help="How old is your gerbil?")
    parser.parse_args()

if __name__ == "__main__":
        main()
