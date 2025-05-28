package Data::DNS::TLD;
# ABSTRACT: an object representing a top-level domain.
use Carp;
use Data::DNS;
use ICANN::gTLD;
use base qw(Net::DNS::Domain);
use vars qw($KNOWN_TYPES);
use constant {
    TYPE_GTLD       => 0,
    TYPE_SPONSORED  => 1,
    TYPE_INFRA      => 2,
    TYPE_CCTLD      => 3,
};
use common::sense;

$KNOWN_TYPES = {
    gov     => TYPE_SPONSORED,
    mil     => TYPE_SPONSORED,
    edu     => TYPE_SPONSORED,
    arpa    => TYPE_INFRA,
};

sub new {
    my ($package, $tld) = @_;

    if (!Data::DNS->exists($tld)) {
        carp("Non-existent TLD '$tld'");

    } else {
        return $package->SUPER::new($tld);

    }
}

sub type {
    my $self = shift;

    if (exists($KNOWN_TYPES->{$self->name})) {
        #
        # known type
        #
        return $KNOWN_TYPES->{$self->name};

    } elsif (2 == length($self->name)) {
        #
        # all 2-character TLDs are ccTLDs
        #
        return TYPE_CCTLD;

    } elsif (ICANN::gTLD->get($self->name)) {
        #
        # TLD is present in the ICANN gTLD list
        #
        return TYPE_GTLD;

    } else {
        #
        # IDN ccTLD
        #
        return TYPE_CCTLD;

    }
}

sub rdap_record { Net::RDAP->new->fetch(URI->new(q{https://rdap.iana.org/domain/}.shift->name)) }
sub gtld_record { ICANN::gTLD->get(shift->name) }
sub rdap_server { Net::RDAP::Service->new_for_tld(shift->name) }
sub top_domain  { Data::Tranco->top_domain(shift->name) }
sub top_domains { Data::Tranco->top_domains(pop, shift->name) }

1;

=pod

=head1 SYNOPSIS

    use Data::DNS;

    if (Data::DNS->exists("org")) {
        $org = Data::DNS->get("org");

        say ".org is operated by ".$org->rdap_record->registrant->jcard->first('org')->value;
    }

=head1 DESCRIPTION

C<Data::DNS::TLD> objects represent top-level domains in the DNS root zone. To
instantiate an instance, use the C<get()> method of L<Data::DNS>.

C<Data::DNS::TLD> inherits from L<Net::DNS::Domain>, so all of its methods are
also available.

=head1 OBJECT METHODS

=head2 type()

This method returns one of the following:

=over

=item * C<Data::DNS::TLD::TYPE_GTLD> - the TLD is a "generic" TLD.

=item * C<Data::DNS::TLD::TYPE_SPONSORED> - the TLD is a "sponsored" TLD.

=item * C<Data::DNS::TLD::TYPE_INFRA> - the TLD is an "infrastructure" TLD.

=item * C<Data::DNS::TLD::TYPE_CCTLD> - the TLD is a "country-code" TLD.

=back

=head2 rdap_record()

This methods queries the IANA RDAP server and returns a
L<Net::RDAP::Object::Domain> object for the TLD.

=head2 gtld_record()

This method queries the ICANN gTLD database and returns a L<ICANN::gTLD> object
for the TLD. This method will return C<undef> if the TLD is not a gTLD.

=head2 rdap_server()

This method returns a L<Net::RDAP::Service> object corresponding to the RDAP
Base URL registered with IANA (if any).

=head2 top_domain()

This method uses L<Data::Tranco> to find the most "popular" domain name within
the TLD.

=head2 top_domains($count)

This method uses L<Data::Tranco> to find the C<$count> most "popular" domain
names within the TLD.
