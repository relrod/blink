#!/usr/bin/env perl
#@ Ricky Elrod - Lang.pm
#@ Modified: Wed Sep 23 20:02:55 EDT 2009

use warnings;
use strict;
use WebService::Google::Language;
#use XML::Simple; # Screw this, using the DICT protocol now.
use Net::Dict;
use URL;
use LWP::UserAgent;

package Lang;
use Data::Dumper;
sub translate {
	# Three args: FROM, TO, TEXT
	my $from = shift;
	my $to = shift;
	my $text = shift;
	
	my $service = WebService::Google::Language->new(
		'referer' => 'http://eighthbit.net',
		'src'     => $from,
		'dest'    => $to
	);
	my $result = $service->translate($text);
	if($result->error){
		return "An error has occured: ".$result->message;
	} else {
		return "`-> ".$result->translation;
	}
}

sub define {
	my $word = shift;
   my $dict = Net::Dict->new('dict.org');
   $dict->setDicts('wn', 'web1913');
   my $proc = $dict->define($word);
   my $definition = $proc->[0]->[1];
   $definition =~ s/\n//g;
   $definition =~ s/\r//g;
   $definition =~ s/\t//g;
   $definition =~ s/ +/ /g;
   $definition = substr($definition, 0, 275);
   return $definition;
}

1; # Make perl happy. :D
