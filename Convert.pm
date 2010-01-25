#!/usr/bin/env perl
#@ Ricky Elrod - Convert.pm
#@ Modified: Thu Sep 17 18:08:12 EDT 2009

use warnings;
use strict;
use WWW::Google::Calculator;

package Convert;
sub calculate {
   my $eq = shift;
   my $calc = WWW::Google::Calculator->new();
   return $calc->calc($eq);
}

1; # Perl!!!!!!1111111
