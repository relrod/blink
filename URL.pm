#!/usr/bin/env perl
#@ Ricky Elrod - URL.pm
#@ Modified: Sat Oct 03 18:06:17 EDT 2009

# This is for the URL-* set of modules for Blink.
# For simple stuff like the is.gd module, we use make our own function,
# so we don't have to rely on some other module being installed.

use warnings;
use strict;
use Image::Size;
use LWP::UserAgent;
use HTML::Entities;
use URI::Escape;

package URL;

sub getcontents {
	my $url = shift;
   my $picture = shift || 0;
	# $url really *should* be prefixed with http:// or https://... but if it wasn't...
	# lets just throw a simple check in and append http:// if it's not in $url.
	if($url !~ /^https?:\/\//i){
		$url = 'http://'.$url;
	}
	my $ua = LWP::UserAgent->new;
   my $contents;
   $ua->agent('Mozilla/5.0 (X11; U; FreeBSD i386; ru-RU; rv:1.9.1.3) Gecko/20090913 Firefox/3.5.4');
   if($picture){
      $ua->timeout(8);
      $ua->max_size(524288);
      $contents = $ua->get($url)->decoded_content;
   } else {
   	$ua->timeout(5);
   	$ua->max_size(1990);
      $contents = $ua->get($url)->decoded_content;
      $contents =~ s/[^(\x20-\x7F)]*//g;
   }
   if($contents){
   	return $contents;
   } else {
      return -1;
   }
}

sub shorten {
	# 1 arg: string - URL in Long form.
	# If we're given an is.gd link, just echo it back.
	my $long_url = shift;
	my $short_url;
	$short_url = getcontents("http://is.gd/api.php?longurl=$long_url");
   if($short_url == -1){
      return "Exceeded timeout.";
   }
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
   if($contents == -1){
      return "Exceeded timeout.";
   }
	$contents =~ s/\r//g;
	$contents =~ s/\n//g;
   if($contents =~ /<title>(.*)<\/title>/i){
		my $title = $1;
		$title =~ s/<(?:[^>'"]*|(['"]).*?\1)*>//gs;
		return HTML::Entities::decode_entities($title);
	} else {
		return 'No <title> tag found.';
	}
} 

sub imagesize {
	my $url = shift;
	my $img = getcontents($url,1);
	my($width,$height) = Image::Size::imgsize(\$img);
	return $width.'x'.$height.' px';
}

1; # Make perl happy. :D
