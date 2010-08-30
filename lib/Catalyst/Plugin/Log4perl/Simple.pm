package Catalyst::Plugin::Log4perl::Simple;
use Moose;
use namespace::autoclean;

=head1 NAME

Catalyst::Plugin::Log4perl::Simple - Simple Log4perl setup for Catalyst application

=head1 VERSION

Version 0.003

=cut

our $VERSION = '0.003';

use List::Util qw( first );
use Catalyst::Log::Log4perl;

=head1 SYNOPSIS

 use Catalyst qw/ ... Log4Perl::Simple /;

 $c->log->warn("Now we're logging through Log4perl");

This is a trivial Catalyst plugin that searches for a log4perl configuration
file and uses it to configure Catalyst::Log::Log4perl as the logger for your
application. If no configuration is found, a sensible default is provided.

For an application My::App, the following locations are searched:

=over 4

=item my_app_log.conf

=item log.conf

=item ../my_app_log.conf

=item ../log.conf

=item /etc/my_app_log.conf

=item /etc/my_app/log.conf

=back

=cut

sub setup {
    my $package = shift;
    my $pkgname = ref $package || $package;

    my $confname = lc $package;
    $confname =~ s/::/_/g;

    my $logpath = first { -s $_ }
      ( "${confname}_log.conf", "log.conf",
        "../${confname}_log.conf", "../log.conf",
        "/etc/${confname}_log.conf", "/etc/$confname/log.conf" );
    if (defined $logpath) {
        $package->log(Catalyst::Log::Log4perl->new($logpath));
    } else {
        $package->log(Catalyst::Log::Log4perl->new());
        $package->log->warn('no log4perl configuration found');
    }

    $package->maybe::next::method(@_);
}

=head1 AUTHOR

Peter Corlett, C<< <abuse at cabal.org.uk> >>

=head1 BUGS

Versions earlier than 0.002 were overcomplicated and used a now-deprecated
NEXT method. Under recent Catalyst, this would break plugins listed after it
in the "use Catalyst" line.

=head1 SEE ALSO

Catalyst::Log::Log4perl

=head1 COPYRIGHT & LICENSE

Copyright 2009,2010 Peter Corlett, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;
1;
