#!/usr/bin/env perl
#@ Ricky Elrod - URL.pm
#@ Modified: Sat Sep 26 13:15:27 EDT 2009

# This is for the URL-* set of modules for Blink.
# For simple stuff like the is.gd module, we use make our own function,
# so we don't have to rely on some other module being installed.

use warnings;
use strict;
use Image::Size;
use LWP::UserAgent;
#use HTML::Entities;
use URI::Escape;

package URL;

sub getcontents {
	my $url = shift;
	# $url really *should* be prefixed with http:// or https://... but if it wasn't...
	# lets just throw a simple check in and append http:// if it's not in $url.
	if($url !~ /^https?:\/\//i){
		$url = 'http://'.$url;
	}
	my $ua = LWP::UserAgent->new;
	$ua->timeout(5); #TODO-LATE: Store these settings in a database.
	$ua->max_size(1220);
	return $ua->get($url)->decoded_content;
}

sub shorten {
	# 1 arg: string - URL in Long form.
	# If we're given an is.gd link, just echo it back.
	my $long_url = shift;
	my $short_url;
	$short_url = getcontents("http://is.gd/api.php?longurl=$long_url");
	if($short_url =~ /The URL you entered is on our blacklist /){
		return $long_url;
	}
	# We didn't return above, so we're valid, lets return.
	return $short_url;
}

sub lengthen {
	#TODO: This will work one day.
	#Mainly it is a PITA, because we have to parse headers.
}

sub title {
	# 1 arg: string - URL in full, 'http://' form.
	my $url = shift;
	my $contents = getcontents($url);
	$contents =~ s/\r//g;
	$contents =~ s/\n//g;
	if($contents =~ /<title>(.*)<\/title>/i){
		return $1;
	} else {
		return 'No <title> tag found.';
	}
} 

sub imagesize {
	my $url = shift;
	my $img = getcontents($url);
	my($width,$height) = Image::Size::imgsize(\$img);
	return $width.'x'.$height.' px';
}

1; # Make perl happy.
