use 5.008;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Text::TinyTemplate',
    VERSION_FROM => 'lib/Text/TinyTemplate.pm',
    ABSTRACT     => 'Small and simple template engine inspired by Mojo::Template',
    AUTHOR       => 'Yasuyoshi Sako',
    LICENSE      => 'perl',
    MIN_PERL_VERSION => '5.008',
    PREREQ_PM    => {},   # no non-core dependencies
    META_MERGE   => {
        resources => {
            repository => 'https://github.com/yasuyoshisako/Text-TinyTemplate',
            bugtracker => 'https://github.com/yasuyoshisako/Text-TinyTemplate/issues',
        },
    },
);
