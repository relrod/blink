#!/usr/bin/env perl
#@ Ricky Elrod - Astro.pm
#@ Modified: Fri Oct 23 21:56:37 EDT 2009

use warnings;
use strict;

package Astro;
use Weather::Google;
use Data::Dumper;

sub fetchweather {
	my $location = shift;
   my $wxobj = Weather::Google->new($location);
   my $cond = $wxobj->current();
   if(exists($cond->{"condition"}) != 1) {
      return "Sorry, conditions for '$location' could not be found.";
   } else {
      my $city = $wxobj->{"info"}->{"city"};
      # And throw it into some vars.
      my $humidity = $cond->{"humidity"};
      my $tempf = $cond->{"temp_f"};
      my $tempc = $cond->{"temp_c"};
      my $wind = $cond->{"wind_condition"};
      my $conditions = $cond->{"condition"};
      return 
         "Conditions for $city: $conditions. $humidity -- $tempf°F ($tempc°C) -- $wind.";
   }
}

1; # Make perl happy.
