#!/usr/bin/perl -w

use strict;
use Switch;
use IO::Socket::UNIX qw( SOCK_STREAM );
use JSON::XS;
use Data::Dumper;
$Data::Dumper::Indent = 1;
$Data::Dumper::Terse  = 1;


$ARGV[0] or die("Usage: status.pl <socket> [ips|keys|json]\n");

my $socket = IO::Socket::UNIX->new(
   Type => SOCK_STREAM,
   Peer => $ARGV[0],
)
   or die("Can't connect to server: $!\n");

my $json_array = decode_json (<$socket>);

if( defined $ARGV[1] ) {
switch ($ARGV[1]) {
    case "ips" {
        foreach my $fastdkey (keys %{ $json_array->{peers} }) {
        print $json_array->{peers}->{$fastdkey}->{address};
        print "\n";
        }
    }
    case "keys" {
        foreach my $fastdkey (keys %{ $json_array->{peers} }) {
        print $fastdkey;
        print "\n";
        }
    }
    case "json" {
        print Dumper $json_array;
    }
    }
} else {
    my $i = 1;
    foreach my $fastdkey (keys %{ $json_array->{peers} }) {
    print "peer $i\n";
    print "address:  $json_array->{peers}->{$fastdkey}->{address}\n";
    print "fastdkey: $fastdkey\n";
    print "mac:      $json_array->{peers}->{$fastdkey}->{connection}->{mac_addresses}->[0]\n";
    $i++;
    }
}

