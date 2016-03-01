#!/usr/bin/perl

use strict;
use warnings;
use Config;

print "$Config{osname}\n";
print "$Config{archname}\n";
print "$Config{osvers}\n";
