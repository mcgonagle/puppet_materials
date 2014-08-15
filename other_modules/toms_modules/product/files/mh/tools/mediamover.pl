#!/usr/bin/perl
#
# mediamover.pl
#
# $Id: mediamover.pl,v 1.6 2009/07/14 17:16:18 wflynn Exp $
#
# WFlynn 06/09
#
# Stupid script for copying and listing v4 media files for migration from one volume to another
#
use DB_File;
use File::Copy;
use File::Find;
use File::Path;
use strict;

my $DEBUG=0;

my %contenthash;
my $contenthashfile="/var/tmp/contentlist.db";

umask 0022;

my $SOURCEDIR="v4media";
my $TARGDIR="v4_media";
my $ISFILERX=qr/^.+?\-.+?\..+$/;
my $ISIMGRX=qr/^\d+?\-\w+?\.\w+?$/;
my $DATE = `date`;
my $DFC=0;
my $SFC=0;
my $FCMOD=10000;

tie (%contenthash, "DB_File", $contenthashfile, O_RDWR|O_CREAT, 0666, $DB_HASH)
    or die "Cannot open file $contenthashfile: $!\n";

if ($DEBUG) {
    finddepth ({ wanted => \&test_process, follow => 1, follow_fast => 1, follow_skip => 2 }, "/$SOURCEDIR");
} else {
    open(FILELIST, ">> /tmp/filelist.txt") or die "Can't open filelist: $!\n";
    open(CONTENTLIST, ">> /tmp/contentlist.txt") or die "Can't open contentlist: $!\n";
    open(OUTPUT, "> /tmp/mediamover.out") or die "Can't open output: $!\n";
    select OUTPUT;
    $|=1;

    print OUTPUT "START:\t$DFC\t$SFC\t$DATE\n";
    finddepth ({ wanted => \&process, follow => 1, follow_fast => 1, follow_skip => 2 }, "/$SOURCEDIR");
    print OUTPUT "DONE:\t$DFC\t$SFC\t$DATE\n";
    $DATE = `date`;

    close(CONTENTLIST);
    close(FILELIST);
    close(OUTPUT);
}

sub process() {
    my $srcfile = $File::Find::name;
    my $trgdir = $File::Find::dir;
    my $trgfile = $srcfile;
    my $mfileid = &getcontentid($_);
    if ($mfileid) {
	unless  ($contenthash{$mfileid}) {
	    $trgdir =~ s/$SOURCEDIR/$TARGDIR/g;
	    $trgfile =~ s/$SOURCEDIR/$TARGDIR/g;
	    if ($srcfile =~ /$ISFILERX/) {
		mkpath($trgdir);
		if (copy($srcfile, $trgfile)) {
		    $contenthash{$mfileid}++;
		    print CONTENTLIST "$mfileid\n";
		    print FILELIST "$srcfile\n";
		}  else {
		    $DATE = `date`;
		    print OUTPUT ("$DFC\t$SFC\t$DATE\tCouldn't copy: $srcfile to $trgfile: $!\n");
		}
	    }
	    ($DFC++ % $FCMOD) || print OUTPUT "Done:\t$DFC\tSkpt:$SFC\n";
	} else {
	    ($SFC++ % $FCMOD) || print OUTPUT "Skpt:\t$SFC\tDone:$DFC\n";
	}
    }
}

sub test_process() {
    my $mfileid = &getcontentid($_);
    print "Content:\t$_\n";
    if ($mfileid) {
	if  ($contenthash{$mfileid}) {
	    print "In Hash:\t$mfileid\n";
	} else {
	    print "No Hash:\t$mfileid\n";
	}
    }
}

sub getcontentid() {
    my $content=shift;
    if ($content =~ /$ISFILERX/) {
	my ($contentid, $garbage) = split('-', $content);
	return($contentid);
    } else {
	return(0);
    }
}
