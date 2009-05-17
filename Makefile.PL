use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Catalyst::Plugin::Log4perl::Simple',
    AUTHOR              => 'Peter Corlett <abuse@cabal.org.uk>',
    VERSION_FROM        => 'lib/Catalyst/Plugin/Log4perl/Simple.pm',
    ABSTRACT_FROM       => 'lib/Catalyst/Plugin/Log4perl/Simple.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
	'Catalyst::Log::Log4perl' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Catalyst-Plugin-Log4perl-Simple-*' },
);
