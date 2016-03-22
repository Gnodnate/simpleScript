#!/usr/bin/env perl

$a = 0;

sub changeA
{
	$a = 1;
}
print $a."\n";
changeA();
print $a."\n";
if (1 eq $a)
{
	print "a =1\n";
}
else
{
	print "a!=1\n";
}
