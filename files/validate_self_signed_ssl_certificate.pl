#!/usr/bin/env perl
use strict;
use warnings;

use Getopt::Std;
use Time::Piece;
use Time::Seconds;
use Data::Dumper;

our $VERSION = '0.01';

$Getopt::Std::STANDARD_HELP_VERSION = 1;
our( $opt_h, $opt_p, $opt_s, $opt_d );
getopts('hp:s:d:');
my $DATADIR = $opt_p;
my $SUBJECT = $opt_s;
my $DAYS = $opt_d;
my $view_cert_command = 'openssl x509 -noout -text -in ';

if( $opt_h || ! defined( $DATADIR ) || ! defined( $SUBJECT ) || ! defined( $DAYS ) ){
  HELP_MESSAGE();
  exit 1;
}

my $result = 0;
foreach my $cert ( 'server', 'root' ){
  my $cert_params = parse_cert( $cert );
  my $subject = parse_subject( $SUBJECT );
  my @cert_stats = stat("$DATADIR/$cert.crt");
  $subject->{'file_stat'} = gmtime( $cert_stats[9] )->strftime;
  $result += evaluate_results( $cert_params, $subject, $DAYS );
  # print Dumper $subject, $cert_params;
}

print $result;
exit $result;

sub VERSION_MESSAGE {
  print "$0 -- version: $VERSION \n";
  return;
}

sub HELP_MESSAGE {
  # VERSION_MESSAGE();
  print <<"END_OF_USAGE";

Usage: $0 -p /var/lib/postgresql/9.3/main -s '/C=US/ST=GA/L=Atlanta/O=YMDPartnersLLC/CN=pg.example.com/emailAddress=dba\@example.com' -d 3650
	-h 		Display this usage message and exit
	-p 		provide a Path to the postgresql \$PG_DATA directory
	-s 		provide the -subj line used to create the certificate being tested
	-d 		provide the -days argument used to build certificate being tested
	--version	Display the script's version number
			The -p, -s and -d switches are required.

END_OF_USAGE
  return;
}

sub evaluate_results {
  my $got = shift;
  my $expected = shift;
  my $days = shift;

  my $result = 0;
  my @keys = keys %{$expected};
  KEY: foreach my $key ( @keys ){
    if ( $key =~ /^(before|after|file_stat)$/ ){ next KEY; }
    unless( exists( $got->{ $key } ) && exists( $expected->{ $key } ) ){
      print STDERR "$key not defined in both \$got and \$expected \n";
      next KEY;
    }
    unless ( $got->{ $key } eq $expected->{ $key } ){
      print STDERR "Certificate fails to match data for $key \n";
      $result++;
    }
  }

  $result += evaluate_result_dates( $got, $expected, $days );
  return $result;
}

sub evaluate_result_dates {
  my $got = shift;
  my $expected = shift;
  my $days = shift;
  my $result = 0;

  # print 'file_stat: ' . $expected->{'file_stat'} . "\n";
  # print 'before: ' . $got->{'before'} . "\n";
  # print 'after: ' . $got->{'after'} . "\n";

  my $format = '%a, %d %b %Y %T';
  # print "$format \n";
 
  $expected->{'file_stat'} =~ s/ UTC$//;
  $got->{'before'} =~ s/ UTC$//;
  $got->{'after'} =~ s/ UTC$//;

  my $file_stat = Time::Piece->strptime( $expected->{'file_stat'}, $format );
  my $before = Time::Piece->strptime( $got->{'before'}, $format );
  my $after = Time::Piece->strptime( $got->{'after'}, $format );

  unless( $file_stat - $before < ( 5 * 60 ) ){
    print STDERR "Certificate file created more than five minutes after cert's Not Before timestamp.\n";
    $result++;
  }
  if( $before + ( 60*60*24*( $days - 1 ) ) > $after  
          || $before + ( 60*60*24*( $days +2 ) ) < $after ){
    print STDERR "Certificate's Not After date outside of tolerance: \n";
    print STDERR "    Not Before: " . $got->{'before'} . "\n";
    print STDERR "    Not After : " . $got->{'after'} . "\n";
    print STDERR "    -days     : $days \n";
    $result++;
  }

  return $result;
}

sub get_cert_contents {
  my $view_cert = shift;
  my @cert_content = split "\n", $view_cert;
  return \@cert_content;
}

sub parse_subject {
  my $subject = shift;
  my %subject;
  my @subject_params = split '/', $subject;
  KV: foreach ( @subject_params ){
    my ($key, $value) = split '=', $_;
    unless( defined( $key ) ){ next KV; }
    chomp( $key );
    chomp( $value );
    $subject{$key} = $value;
  }
  return \%subject;  
}

sub parse_cert {
  my $cert = shift;
  my $cert_file = "$DATADIR/$cert.crt";
  my $view_cert = `$view_cert_command $cert_file`;
  my $cert_content = get_cert_contents( $view_cert );
  my %cert_params;
  my @cert_times = map {
    $_ =~ /^\ *Not (.*): (.*)$/;
    my $k = $1;
    my $v = $2;
    $k =~ s/\ *$//;
    $cert_params{ lc( $k ) } = Time::Piece->strptime( $v, '%b %d %T %Y %Z' )->strftime;
    # $cert_params{ lc( $k ) } = $v;
  } grep { /^\ *Not / } @{$cert_content}; 
  my @subject = grep { /^\ *Subject: / } @{$cert_content}; 
  my @kv = split /[:,\/]\ ?/, $subject[0];
  KV: foreach my $kv ( @kv ){
    my ($key, $value) = split '=', $kv;
    if( $key =~ m/Subject/ ){ next KV; }
    $cert_params{$key} = $value;
  }
  return \%cert_params;
}

=head1 NAME 

validate_self_signed_ssl_certificate.pl

=head1 VERSION

Version 0.01

=head1 SYNOPSIS 

perl validate_self_signed_ssl_certificate.pl --help 

will provide a usage message 

This script intended for use by the postgresql::server::ssl_certificate class 
of the puppetlabs-postgresql module to validate the installation of the server.crt 
and the root.crt it installs in a Postgresql $PG_DATA directory.

=head1  COPYRIGHT

Contributed by Hugh Esco <hesco@yourmessagedelivered.com>
YMD Partners LLC
to the puppetlabs-postgresql module
https://github.com/hesco/puppetlabs-postgresql#class-postgresqlserverssl_certificate

~
=cut

