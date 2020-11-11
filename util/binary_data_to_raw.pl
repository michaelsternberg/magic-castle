#!/usr/bin/env perl
# binary_data_to_raw.pl 
# Input:  text file containing strings of decimal numbers
# Output: raw binary data of those decimal numbers
# Used to convert transcribed data found at 
# https://archive.org/stream/magiccastle_atari/Magic%20Castle%20Compiled%20Code
# into raw binary file.
use strict;
use warnings;
use File::Basename;
use Getopt::Std;

sub display_usage();

my $inp_filename;
my $out_filename;
my %opts;

getopts('i:o:', \%opts);

$inp_filename = $opts{i} if defined $opts{i};
$out_filename = $opts{o} if defined $opts{o};

if (! (defined $inp_filename && defined $out_filename))
{
    display_usage();
    exit 1;
}

my @a;
my $curr_page;
my $curr_addr;

my $inp_fp;
my $out_fp;

open $inp_fp, '<',     $inp_filename or die $!;
open $out_fp, '>:raw', $out_filename or die $!;

while (<$inp_fp>)
{
    chomp;

    # Skip blank lines
    next if m/^$/;

    # Page Header 
    # "page" as in 6502 CPU address space = 256 pages of 256 bytes each
    # Unused in output
    if ( m/^PAGE:/ )
    {
        @a = split / /;
        $curr_page = $a[1];
    }
    # Single number denotes next target address (in decimal)
    # Unused in output
    elsif ( m/^[0-9]*$/ )
    {
        @a = split / /;
        $curr_addr = $a[0];
    }
    # Otherwise string of decimal numbers
    # Convert these to raw binary data and write to output file
    else
    {
        @a = split / /;
        foreach my $i (@a)
        {
            print $out_fp pack('C', $i)
        }
    }
}

close $out_fp;
close $inp_fp;

exit;

#-------------------------------------------------------------------------------
#                          S U B R O U T I N E S
#-------------------------------------------------------------------------------

sub display_usage()
{
    print 'Usage: ' . basename($0) . " -i <inputfile> -o <outputfile>\n";
}
