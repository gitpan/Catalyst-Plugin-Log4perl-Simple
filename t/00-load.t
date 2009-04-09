#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Catalyst::Plugin::Log4perl::Simple' );
}

diag( "Testing Catalyst::Plugin::Log4perl::Simple $Catalyst::Plugin::Log4perl::Simple::VERSION, Perl $], $^X" );
