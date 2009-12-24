#!/usr/bin/env perl
#@ Ricky Elrod - Grab.pm
#@ Modified: Mon Oct 12 00:02:38 EDT 2009

use warnings;
use strict;

package Grab;
use DBI;
use Data::Dumper;

#module local hash to track channels->users = messages. This is used by
#fetch_grab_row and other primatives
my $last_seen_messages = {};

my $dbh = DBI->connect("dbi:SQLite:dbname=db_blink.sqlite3","","",{AutoCommit=>1,PrintError=>1});

#prep for queries
my $new_grab = $dbh->prepare("INSERT INTO grabs(by,who,message,channel) VALUES(?,?,?,?)");
my $fetch_grab = $dbh->prepare("SELECT message FROM grabs WHERE who=? AND channel=? ORDER BY RANDOM()");

#return 1 or 0 depending on if the message is new or not.  failure to
#verify that the user has more then one message will cause an infinate
#loop if the only check is done with this.

sub check_seen_messages {
  my ($who, $channel, $message) = @_;
  if( exists $last_seen_messages->{$channel}{$who} and
      $last_seen_messages->{$channel}{$who} eq $message) {
    return 0;
  } else { #update the hash and return 1
    $last_seen_messages->{$channel}{$who} = $message;
    return 1;
  }
}

#debugging function
sub fetch_grab_row {
  my ($who, $channel) = @_;
  $fetch_grab->execute($who,$channel);
  return $fetch_grab->fetchrow_array();
}

#A commit here means adding a new quote to the database.x
sub commit {
	my($commitby,$who,$said,$channel) = @_;
	if($new_grab->execute($commitby,$who,$said,$channel)){
		return 1;
	} else {
		return 0;
	}
}

#Grab one row from the database.
sub fetchr {
	my $who = shift;
	my $channel = shift;
	
	my @data = fetch_grab_row($who, $channel);
	if (@data) {
		return $data[0];
	} else {
		return "No grabbed quotes for $who in this channel.";
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
