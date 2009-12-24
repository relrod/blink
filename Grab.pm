#!/usr/bin/env perl
#@ Ricky Elrod - Grab.pm
#@ Modified: Mon Oct 12 00:02:38 EDT 2009

use warnings;
use strict;

package Grab;
use DBI;
use Data::Dumper;
my $dbh = DBI->connect("dbi:SQLite:dbname=db_blink.sqlite3","","",{AutoCommit=>1,PrintError=>1});

sub commit {
	my($commitby,$who,$said,$channel) = @_;
	my $prep = $dbh->prepare("INSERT INTO grabs(by,who,message,channel) VALUES(?,?,?,?)");
	
	if($prep->execute($commitby,$who,$said,$channel)){
		return 1;
	} else {
		return 0;
	}
}

sub fetchr {
	my $who = shift;
	my $channel = shift;
	my $prep = $dbh->prepare("SELECT message FROM grabs WHERE who=? AND channel=? ORDER BY RANDOM()");
	$prep->execute($who,$channel);
	my @data = $prep->fetchrow_array();
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
