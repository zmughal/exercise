#!/bin/sh

CURDIR=`dirname "$0"`
cd "$CURDIR"

perlbrew exec --with perl-5.20.0-shrplib ./make-change.p6 "1p"
perlbrew exec --with perl-5.20.0-shrplib ./make-change.p6 "2p"
perlbrew exec --with perl-5.20.0-shrplib ./make-change.p6 "3p"
perlbrew exec --with perl-5.20.0-shrplib ./make-change.p6 "50p"
perlbrew exec --with perl-5.20.0-shrplib ./make-change.p6 "£1.0"
perlbrew exec --with perl-5.20.0-shrplib ./make-change.p6 "£1.00"
perlbrew exec --with perl-5.20.0-shrplib ./make-change.p6 "£2"
