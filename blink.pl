#!/usr/bin/env perl
#@ Ricky Elrod - blink.pl
#@ Modified: Mon Oct 12 20:29:15 EDT 2009

# The start of a new daw-- bot.
# The purpose of this bot is to replace the ruby-coded 'haz' bot, and 
# be better and have more features.
#
# Most of the bot will be coded the same way. Commands will be specified in this file.
# Commands that do advanced things will have functions, which will be in .pm files.
# The first command to be implemented is translate or tr.

use warnings;
use strict;
use encoding 'utf8';

# *GLOBAL* modules.
use LWP::UserAgent;
use Crypt::SSLeay;

# Bot classes go here:
use Lang;
use URL;
use Astro;
use Grab;
use Convert;
use GitHub;

package Blink;
use base qw( Bot::BasicBot );
use Data::Dumper;
use Math::BaseCnv;
my $version = "1.0";

# Welcome to the world of !grab
my $grabs;
my $action;

sub said {
	my $self       = shift;
	my $info       = shift;
	my $text       = $info->{body};
	my $nick       = $info->{who};
	my $rawnick    = $info->{raw_nick};
	my @rlmask     = split(/\@/,$rawnick);
	my $mask       = $rlmask[1];
	my $channel    = $info->{channel};
	my $is_action  = $action;
	undef($action);


	$grabs->{$channel}->{lc($nick)}->{'text'} = $text;
	$grabs->{$channel}->{lc($nick)}->{'action'} = $is_action;

   if($nick !~ /(?:Sneeze)/i){
   	
   	if($text =~ /^!version$/i){
   		$self->reply($info,"Blink. Version $version. By CodeBlock. *blink blink*.");
   	}

      elsif($text =~ /^!github ([\w\d\-\.\,]+)\/([\w\d\-\.\,]+)/i){
         $self->reply($info, GitHub::repoinfo($1,$2));
      }
   
   	elsif($text =~ /^!(?:translate|tr|lang) ([\w]+)\|([\w]+) (.*)/i){
   		# From, To, Stuff.
   		my $translation = Lang::translate($1,$2,$3);
   		return $translation;
   	}

      elsif($text =~ /^!(?:base|baseconvert|convert) ([\d-]+) ([\d-]+) ([\d-]+)/i){
         my $conv = cnv($3,$1,$2);
         return "$nick: $3 (base $1) in the base of $2 is... $conv";
      }
   
   	elsif($text =~ /(?:\[|<)(https?:\/\/[\S\.]+)(?:\]|>)/i){
   		my $shorturl = URL::shorten($1);
   		if($1 =~ /.*\.(?:jpg|gif|psd|bpm|png|jpeg|tiff|tif)/i){
   			# Image....obviously.
   			my $imagesize = URL::imagesize($shorturl);
   			return "$shorturl - $imagesize";
   		} else {
   			# Otherwise, assume a legitimate, real, site.
   			my $title = URL::title($1);
   			return "$shorturl :: $title";
   		}
   	}
   
   	elsif($text =~ /^!(?:dict|define) (.*)/i){
   		my $word = $1;
   		my $definition = Lang::define($word);
   		return $definition;
   	}

      elsif($text =~ /^!colorwheel$/i) {
         my $colorwheel = "";
         $colorwheel  = chr(3).'1,00 0 '.chr(3) . chr(3).'0,01 1 '.chr(3);
         $colorwheel .= chr(3).'0,02 2 '.chr(3) . chr(3).'0,03 3 '.chr(3);
         $colorwheel .= chr(3).'0,04 4 '.chr(3) . chr(3).'0,05 5 '.chr(3);
         $colorwheel .= chr(3).'0,06 6 '.chr(3) . chr(3).'0,07 7 '.chr(3);
         $colorwheel .= chr(3).'1,08 8 '.chr(3) . chr(3).'1,09 9 '.chr(3);
         $colorwheel .= chr(3).'0,10 10 '.chr(3) . chr(3).'1,11 11 '.chr(3);
         $colorwheel .= chr(3).'0,12 12 '.chr(3) . chr(3).'1,13 13 '.chr(3);
         $colorwheel .= chr(3).'0,14 14 '.chr(3) . chr(3).'1,15 15 '.chr(3);
         return $colorwheel;
      }

   
   	elsif($text =~ /^!join #([\w\-\d\`\_\#]+)/i){
   		my $channel = $1;
   		$self->join("#$channel");
   		return;
   	}

      elsif($text =~ /^!(?:calc|gcalc|googlecalc|calculate|math) (.+)/i){
         my $eq = $1;
         return Convert::calculate($eq);
      }
   
   	elsif($text =~ /^!(?:wx|weather|w) ([\w\,\ \d]+)/i){
   		my $location = $1;
   		my $weather = Astro::fetchweather($location);
   		return $weather;
   	}
   
   	elsif($is_action and $text =~ /^sneezes/i){
   		return "blinks.";
   	}
   
   	elsif($text =~ /^!(grab|get|grope) ([\w\-\d\`\_]+)/i){
   		my $command = $1;
   		my $who = lc($2);
   		if(defined($grabs->{$channel}->{$who}->{'text'})){
   			my $quote = $grabs->{$channel}->{$who}->{'text'};
   			if(lc($quote) eq lc("!$command $who")){
   				return "Cannot grab your own quote....";
   			} elsif(lc($who) eq "blink") {
               return "I will not grab myself. Ever.";
            }
   
   			if($grabs->{$channel}->{$who}->{'action'}){
   				$quote = "* $who $quote";
   			} else {
   				$quote = "<$who> $quote";
   			}
   			if(!Grab::commit($nick,$who,$quote,$channel)){
   				$self->say(who=>"#codeblock",body=>"An error has occured while executing Grab::commit(). [$nick] [$who] [$quote]");
   			}
   			if($command eq "grab" or $command eq "get"){
   				return "Grabbed $who\'s last quote.";
   			} elsif($command eq "grope"){
   				return chr(1)."ACTION gropes $who".chr(1);
   			}
   
   		} else {
   			return "$who hasn't spoken yet, so I cannot grab his/her latest quote.";
   		}
   	}
   
   	elsif($text =~ /!(?:qc|quotecount|count|grabcount) (.*)/i){
   		my $who = lc($1); #lc() for backwards compat.
   		return Grab::count($who,$channel);
   	}
   
   	elsif($text =~ /^!rq ([\w\-\d\`\_]+)/i){
   		my $who = lc($1); #lc() for backwards compat.
   		return Grab::fetchr($who,$channel);
   	}
   }
   	return;
}
   
sub emoted {
   $action = 1;
   shift->said(@_);
}

my $eighthbit = Blink->new(
	server      => "irc.eighthbit.net",
	port        => 6667,
   ssl         => 0,
   channels    => ["#illusion","#offtopic","#programming", "#codeblock", "#bots", "#ubuntu-advanced"],
   #channels    => ["#bots"],
	nick        => "Blink",
	username    => "sneeze",
	name        => "Blink-Blink..what's a name?",
	charset     => "utf-8",
   no_run      => 1,
);


my $fuse = Blink->new(
	server      => "irc.fuseirc.net",
	port        => 6667,
	channels    => ["#main"],
	nick        => "Blink",
	username    => "sneeze",
	name        => "Blink-Blink..what's a name?",
	charset     => "utf-8",
	no_run      => 1,
);

$eighthbit->run();
#$fuse->run();
use POE;
$poe_kernel->run();
