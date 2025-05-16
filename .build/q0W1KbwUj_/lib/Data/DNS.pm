package Data::DNS;
# ABSTRACT: An interface to the DNS root zone database.
use Carp;
use Data::DNS::TLD;
use Data::Mirror qw(mirror_str);
use Data::Tranco;
use ICANN::gTLD;
use Net::RDAP;
use constant TLD_LIST_URL => q{https://data.iana.org/TLD/tlds-alpha-by-domain.txt};
use vars qw($VERSION @TLDs);
use common::sense;

$VERSION = q{0.01};

BEGIN {
    @TLDs = map { lc } grep { /^([a-z]+|xn--[a-z0-9\-]+)$/i } split(/\n/, mirror_str(TLD_LIST_URL));
}

sub tld_exists  { any { lc($_[1]) eq $_ } @TLDs }
sub get         { Data::DNS::TLD->new($_[1]) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::DNS - An interface to the DNS root zone database.

=head1 VERSION

version 0.01

=head1 AUTHOR

Gavin Brown <gavin.brown@icann.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2025 by Internet Corporation for Assigned Names and Numbers (ICANN).

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
