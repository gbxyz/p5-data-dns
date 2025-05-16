#!/usr/bin/env perl
use Test::More;
use LWP::Online qw(:skip_all);
use Test::More;
use common::sense;

my $class = q{Data::DNS};

require_ok $class;

done_testing;
