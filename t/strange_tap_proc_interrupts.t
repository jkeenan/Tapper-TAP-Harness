#! /usr/bin/env perl

use strict;
use warnings;

use Test::More;

use Artemis::TAP::Harness;
use File::Slurp 'slurp';
use Data::Dumper;
use Test::Deep;

plan tests => 4;

my $tap;
my $harness;
my $interrupts_before_section;

# ============================================================

$tap     = slurp ("t/tap_archive_kernbench4.tap");
$harness = new Artemis::TAP::Harness( tap => $tap );
$harness->evaluate_report();

print STDERR Dumper($harness->parsed_report->{tap_sections});
# foreach (map { $_->{section_name} }  @{$harness->parsed_report->{tap_sections}})
# {
#         diag "Section: $_";
# }

is( scalar @{$harness->parsed_report->{tap_sections}}, 18, "kernbench4 section name interrupts-before count");
cmp_bag ([ map { $_->{section_name} } @{$harness->parsed_report->{tap_sections}}],
         [
          qw/
                    artemis-meta-information
                    stats-proc-interrupts-before
                    kernel-untar
                    kernbench-untar
                    kernbench-testrun
                    section-005
                    kernbench-results
                    kernbench-testrun1
                    section-008
                    kernbench-results1
                    kernbench-testrun2
                    section-011
                    kernbench-results2
                    dmesg
                    var_log_messages
                    stats-proc-interrupts-after
                    clocksource
                    uptime
            /
         ],
         "tap sections");

$interrupts_before_section = $harness->parsed_report->{tap_sections}->[1];
is ($interrupts_before_section->{section_name}, 'stats-proc-interrupts-before', "kernbench4 section name interrupts-before");

like ($harness->parsed_report->{tap_sections}->[1]->{raw}, qr/linetail: IO-APIC-edge  timer/, "raw contains yaml");

