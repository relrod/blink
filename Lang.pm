#!/usr/bin/env perl
#@ Ricky Elrod - Lang.pm
#@ Modified: Wed Sep 23 20:02:55 EDT 2009

use warnings;
use strict;
use WebService::Google::Language;
use XML::Simple;
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
	my $xml = URL::getcontents("http://services.aonaware.com/DictService/DictService.asmx/DefineInDict?dictId=wn&word=$word");
	#my $gettype = XML::Simple::XMLin($xml);
	#my $mainxml = $gettype->{Definitions}->{Definition};
	#return "Definition not found." if(!defined($mainxml));
	#my $type = ref($mainxml);#->[1]->{WordDefinition};
	#my $full;
	#return Data::Dumper::Dumper($full = $gettype->{Definitions}->{Definition});
	#return $xml;
	return "This function is currently broken. Tell CB to get off his lazy behind and fix it.";
	#if($type eq 'HASH'){
	#	$full = $gettype->{Definitions}->{Definition}->{WordDefinition};
	#} elsif ($type eq 'ARRAY'){
	#	$full = $gettype->{Definitions}->{Definition}->[0]->{WordDefinition};
	#}
	#$full =~ s/\n/ /g;
	#$full =~ s/\\'/'/g;
	#$full =~ s/       / /g;
	#$full =~ s/^\S+\s+//;
	#my $truncate = substr($full,0,250);
	#if(length($truncate) < length($full)){
	#	return $truncate.'...';
	#} else {
	#	return $truncate;
	#}

}

#print Dumper(define('broken'));
#print Dumper($test);

1; # Make perl happy.
