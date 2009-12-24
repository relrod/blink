#!/usr/bin/env perl
#@ Ricky Elrod - Grab.pm
#@ Modified: Mon Oct 12 00:02:38 EDT 2009

use warnings;
use strict;

package Grab;
use DBI;
use Data::Dumper;
my $dbh = DBI->connect("dbi:SQLite:dbname=db_blink.sqlite3","","",{AutoCommit=>1,PrintError=>1});

#prep for queries
my $new_grab = $dbh->prepare("INSERT INTO grabs(by,who,message,channel) VALUES(?,?,?,?)");
my $fetch_grab = $dbh->prepare("SELECT message FROM grabs WHERE who=? AND channel=? ORDER BY RANDOM()");

sub commit {
	my($commitby,$who,$said,$channel) = @_;
	if($new_grab->execute($commitby,$who,$said,$channel)){
		return 1;
	} else {
		return 0;
	}
}

sub fetchr {
	my $who = shift;
	my $channel = shift;
	
	$fetch_grab->execute($who,$channel);
	my @data = $fetch_grab->fetchrow_array();
	if(int(@data) != 0){
		return @data[int(rand(@data))]
	} else {
		return "No grabbed quotes for $who, in this channel.";
	}
}

sub count {
	my $who = shift;
   my $channel = shift;
	my $numrows = $dbh->selectrow_array('SELECT COUNT(*) FROM grabs WHERE who=? AND channel=?',undef,$who, $channel);
	if(int($numrows)){
      return "$who has ".int($numrows)." quotes in $channel.";
   } else {
      return "$who hasn't been grabbed in $channel, yet.";
   }
}

1; # Make perl happy. :D
