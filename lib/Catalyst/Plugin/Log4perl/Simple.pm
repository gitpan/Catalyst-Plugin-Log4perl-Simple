package Catalyst::Plugin::Log4perl::Simple;

use warnings;
use strict;

=head1 NAME

Catalyst::Plugin::Log4perl::Simple - Simple Log4perl setup for Catalyst application

=head1 VERSION

Version 0.001

=cut

our $VERSION = '0.002';

use List::Util qw( first );
use Catalyst::Log::Log4perl;

=head1 SYNOPSIS

 use Catalyst qw/ ... Log4Perl::Simple /;

 $c->log->warn("Now we're logging through Log4perl");

This is a Catalyst plugin that installs a Log4perl handler as the Catalyst
logger. For an application My::App, it looks for a Log4perl configuration
file in the following locations:

=over 4

=item my_app_log.conf

=item log.conf

=item ../my_app_log.conf

=item ../log.conf

=item /etc/my_app_log.conf

=item /etc/my_app/log.conf

=back

If no configuration file is found, it uses a default.

=cut

# Basically, this code wraps the setup() function that is ultimately called
# to actually boostrap the Catalyst application. It removes this package
# from out of the @ISA of the using package.

# TODO: For some reason it's still called twice even with that, so it keeps
# note of whether it's been called before. Might this be just NEXT not
# getting wind of the @ISA hackery?

# Beyond the wrapping, the code merely looks for a Log4perl configuration
# file using a variety of names based on the application, and then installs
# Log4perl using that configuration as the Catalyst logger.

my $first = 1;
sub setup {
  my $package = shift;
  my $pkgname = ref $package || $package;

  if($first) {
    $first = 0;
    do {
      no strict 'refs';
      @{"${pkgname}::ISA"} = grep { $_ ne __PACKAGE__ } @{"${pkgname}::ISA"};
    };
    my $confname = lc $package;
    $confname =~ s/::/_/g;

    my $logpath = first { -s $_ }
      ( "${confname}_log.conf", "log.conf",
        "../${confname}_log.conf", "../log.conf",
        "/etc/${confname}_log.conf", "/etc/$confname/log.conf" );
    if(defined $logpath) {
      $package->log(Catalyst::Log::Log4perl->new($logpath));
    } else {
      $package->log(Catalyst::Log::Log4perl->new());
      $package->log->warn('no log4perl configuration found');
    }
  }

  $package->NEXT::setup(@_);
};

=head1 AUTHOR

Peter Corlett, C<< <abuse at cabal.org.uk> >>

=head1 BUGS

The rather, umm, special way it hooks in to setup() to get called, and the
subsequent @ISA hacker should probably be improved.

=head1 SEE ALSO

Catalyst::Log::Log4perl

=head1 COPYRIGHT & LICENSE

Copyright 2009 Peter Corlett, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1; # End of Catalyst::Plugin::Log4perl::Simple
