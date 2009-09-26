#!/usr/bin/env perl
#@ Ricky Elrod - blink.pl
#@ Modified: Wed Sep 23 16:24:02 EDT 2009

# The start of a new daw-- bot.
# The purpose of this bot is to replace the ruby-coded 'haz' bot, and 
# be better and have more features.
#
# Most of the bot will be coded the same way. Commands will be specified in this file.
# Commands that do advanced things will have functions, which will be in .pm files.
# The first command to be implemented is translate or tr.

use warnings;
use strict;

# *GLOBAL* modules.
use LWP::UserAgent;
use Crypt::SSLeay;

# Bot classes go here:
use Lang;
use URL;

package Blink;
use base qw( Bot::BasicBot );
use Data::Dumper;
my $version = "1.0";

sub said {
	my $self       = shift;
	my $info       = shift;
	my $text       = $info->{body};
	my $nick       = $info->{who};
	my $rawnick    = $info->{raw_nick};
	my @rlmask     = split(/\@/,$rawnick);
	my $mask       = $rlmask[1];
	my $channel    = $info->{channel};
	
	if($text =~ /^!version$/i){
		$self->reply($info,"Blink. Version $version. By CodeBlock. *blink blink*.");
	}

	elsif($text =~ /^!(?:translate|tr|lang) ([\w]+)\|([\w]+) (.*)/i){
		# From, To, Stuff.
		my $translation = Lang::translate($1,$2,$3);
		return $translation;
	}

	elsif($text =~ /\[(https?:\/\/[\S\.]+)\]/i){
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

	elsif($text =~ /!(?:dict|define) (.*)/i){
		my $word = $1;
		my $definition = Lang::define($word);
		return $definition;
	}
}

my $eighthbit = Blink->new(
	server      => "irc.eighthbit.net",
	port        => 6667,
	channels    => ["#fail","#offtopic"],
	nick        => "Blink",
	username    => "sneeze",
	name        => "Blink-Blink..what's a name?",
	charset     => "utf-8",
	no_run      => 1,
);


my $vega = Blink->new(
	server      => "vega.eighthbit.net",
	port        => 6667,
	channels    => ["#nixeagle","#raw"],
	nick        => "Blink",
	username    => "sneeze",
	name        => "Blink-Blink..what's a name?",
	charset     => "utf-8",
	no_run      => 1,
);

$eighthbit->run();
$vega->run();
use POE;
$poe_kernel->run();

