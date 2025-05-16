package Data::DNS::TLD;
# ABSTRACT: an object representing a top-level domain.
use Carp;
use Data::DNS;
use base qw(Net::DNS::Domain);
use vars qw(%TYPES);
use constant {
    TYPE_GTLD       => 0,
    TYPE_SPONSORED  => 1,
    TYPE_INFRA      => 2,
    TYPE_CCTLD      => 3,
};
use common::sense;

%TYPES = (
    gov     => TYPE_SPONSORED,
    mil     => TYPE_SPONSORED,
    edu     => TYPE_SPONSORED,
    arpa    => TYPE_INFRA,
);

sub new {
    my ($package, $tld) = @_;

    if (!Data::DNS->tld_exists($tld)) {
        carp("Non-existent TLD '$tld'");

    } else {
        return $package->SUPER::new($tld);

    }
}

sub type {
    my $self = shift;
    if (ICANN::gTLD->get($self->name)) {
        return TYPE_GTLD;

    } elsif (exists($TYPES{$self->name}) {
        return $TYPES{$self->name};

    } else {
        return TYPE_CCTLD;

    }
}

sub rdap_record { Net::RDAP->new->fetch(URI->new(q{https://rdap.iana.org/domain/}.shift->name)) }
sub gtld_record { ICANN::gTLD->get(shift->name) }
sub rdap_server { Net::RDAP::Service->new_for_tld(shift->name) }
sub top_domain  { Data::Tranco->top_domain(shift->name) }
sub top_domains { Data::Tranco->top_domains(pop, shift->name) }

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Data::DNS::TLD - an object representing a top-level domain.

=head1 VERSION

version 0.01

=head1 AUTHOR

Gavin Brown <gavin.brown@icann.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2025 by Internet Corporation for Assigned Names and Numbers (ICANN).

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
