#!/usr/bin/env perl

use strict;
use warnings;

use IO::Socket;

my $socket = new IO::Socket::INET(Proto => "udp");
my $ip_address = inet_aton("localhost");
my $portaddr = sockaddr_in(10000, $ip_address);
my $message = '';
while($message ne "exit\n") {
    print "Enter date: ";
    $message = <STDIN>;
    $socket->send($message, 0, $portaddr);
}
