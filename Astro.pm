#!/usr/bin/env perl
#@ Ricky Elrod - Astro.pm
#@ Modified: Fri Oct 23 21:56:37 EDT 2009

use warnings;
use strict;

package Astro;
use Weather::Underground;
use Data::Dumper;

sub fetchweather {
	my $location = shift;
	my $wug = Weather::Underground->new(
		place => $location,
		debug => 0
	);
	my $weatherinfo = $wug->get_weather;
	if(defined($weatherinfo)){
		# Get all the vars we're going to use and put them in
		# a non-evil form (i.e so we can use them without
		# concatting strings.
      my $windresponse;
		my $visibility = $weatherinfo->[0]->{'visibility_miles'};
		my $winddir = $weatherinfo->[0]->{'wind_direction'};
		my $windmph = $weatherinfo->[0]->{'wind_milesperhour'};
      if($windmph eq "0.0"){
         $windresponse = "Wind is nonexistant, at 0.0 MPH";
      } else {
         $windresponse = "Wind is $winddir at $windmph MPH";
      }
		my $place = $weatherinfo->[0]->{'place'};
		my $tempf = $weatherinfo->[0]->{'temperature_fahrenheit'};
		my $tempc = $weatherinfo->[0]->{'celsius'};
		my $humidity = $weatherinfo->[0]->{'humidity'};
		my $conditions = $weatherinfo->[0]->{'conditions'};
                $conditions = 'Clear Sky' if $conditions eq 'Clear';
		return "Weather for ($place): Currently, this location is experiencing $conditions conditions. "
			." $windresponse. Temperature is "
			.$tempf."F (".$tempc."C), and humidity is $humidity%. Visibility is $visibility miles.";
	} else {
		return "Sorry, but weather for '$location' could not be retrieved.";
	}
}

1; # Make perl happy.
