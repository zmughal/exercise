#!/bin/sh

CURDIR=`dirname "$0"`
cd "$CURDIR"

# need shared lib Perl for Inline::Perl5

perlbrew install perl-5.20.0 -Duseshrplib --as perl-5.20.0-shrplib
panda install Term::ProgressBar
perlbrew exec --with perl-5.20.0-shrplib panda install Inline::Perl5
perlbrew exec --with perl-5.20.0-shrplib cpanm Lingua::EN::Inflect

