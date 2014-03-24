package Algorithm::LossyCount::Entry;

use strict;
use warnings;
use v5.10;

sub new {
  my ($class, %params) = @_;

  my $num_allowed_errors = delete $params{num_allowed_errors}
    // Carp::croak('Missing mandatory parameter: "num_allowed_errors"');
  if (%params) {
    Carp::croak(
      'Unknown parameter(s): ',
      join ', ', map { qq/"$_"/ } sort keys %params,
    )
  }

  bless +{
    frequency => 1,
    num_allowed_errors => $num_allowed_errors,
  } => $class;
}

sub frequency { $_[0]->{frequency} }

sub increment_frequency { ++$_[0]->{frequency} }

sub num_allowed_errors {
  my ($self, $new_value) = @_;

  $self->{num_allowed_errors} = $new_value if defined $new_value;
  $self->{num_allowed_errors};
}

sub survive_in_bucket {
  my ($self, $current_bucket) = @_;

  unless (defined $current_bucket) {
    Carp::croak('survive_in_bucket() requires 1 parameter.');
  }

  $self->frequency + $self->num_allowed_errors > $current_bucket;
}

1;
