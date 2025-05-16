#!/usr/bin/env perl
use Test::More;
use LWP::Online qw(:skip_all);
use Test::More;
use common::sense;

my $class = q{Data::DNS};

require_ok $class;

is($class->exists(q{com}), 1);
is($class->exists(q{invalid}), undef);

done_testing;
