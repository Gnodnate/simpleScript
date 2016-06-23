#!/usr/bin/env python

#Filename: mac.py

import random
import sys
import os
import string

def allMACAddress():
    for i in range(0,65535):
        for j in range(0, 65535):
            for k in range(1, 65535):
                macaddress = "%04x.%04x.%04x" % (i, j, k)
                os.system("command %s" % macaddress)
                print macaddress
    else:
        print 'Complete'

def randMACAddress(count):
    i = 0
    while i < count:
        a = random.randint(0, 0xffff)
        b = random.randint(0, 0xffff)
        c = random.randint(0, 0xffff)
        macaddress = "%04x.%04x.%04x" % (a, b, c)
        os.system("command %s" % macaddress)
        print macaddress
        i += 1

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print ''' Usage :
        all: all MAC address from 0000.0000.0000 to ffff.ffff.ffff 
        count: the number of random MAC address. exp: 1000 for 1000 MAC'''
        sys.exit()
        
    if sys.argv[1] == 'all':
        allMACAddress()
    else:
        count =  string.atoi(sys.argv[1])
        randMACAddress(count)
