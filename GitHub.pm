#!/usr/bin/env perl
#@ Ricky Elrod - GitHub.pm

use warnings;
use strict;

package GitHub;
use Net::GitHub;
use Net::GitHub::V1::Project::Info;
use Net::GitHub::V2::Users;
use Data::Dumper;

sub repoinfo {
   my $input_username = shift;
   my $repo = shift;
   
   # Step One: Get real username (case-correct)
   my $user_obj = Net::GitHub::V2::Users->new( owner=>$input_username );
   my $real_username = $user_obj->search($input_username)->[0]->{"username"};
   my $username = $real_username; # Just for code clarity.
   

   # Step Two: Find the repo.
   $repo = Net::GitHub::V1::Project::Info->new(
      owner=>$username, name=>$repo
   );

   # Step Three: Return if we didn't find the repo.
   if(( $repo->watcher_num eq "" ) and ( $repo->description eq "" )) {
      return "Unable to locate '$input_username/".$repo->name."' on github.";
   }

   # Step Four: Return the info.
   return "$username/".$repo->name.": ".$repo->description
      ." -- Public clone command: ".chr(3)."03".$repo->public_clone_url.chr(3)
      ." -- currently ".$repo->watcher_num." watcher(s).";
}

1; # Make perl happy.
