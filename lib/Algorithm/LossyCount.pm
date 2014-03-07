package Algorithm::LossyCount;

# ABSTRACT: Memory-efficient approximate frequency count.

use v5.14;
use Algorithm::LossyCount::Entry;
use Carp;
use POSIX qw//;

our $VERSION = 0.01;

sub new {
  my ($class, %params) = @_;

  my $max_error_ratio = delete $params{max_error_ratio}
    // Carp::croak('Missing mandatory parameter: "max_error_ratio"');
  if (%params) {
    Carp::croak(
      'Unknown parameter(s): ',
      join ', ', map { qq/"$_"/ } sort keys %params,
    )
  }

  Carp::croak('max_error_ratio must be positive.') if $max_error_ratio <= 0;

  my $self = bless +{
    bucket_size => POSIX::ceil(1 / $max_error_ratio),
    current_bucket => 1,
    entries => +{},
    max_error_ratio => $max_error_ratio,
    num_samples => 0,
    num_samples_in_current_bucket => 0,
  } => $class;

  return $self;
}

sub add_sample {
  my ($self, $sample) = @_;

  Carp::croak('add_sample() requires 1 parameter.') unless defined $sample;

  if (defined (my $entry = $self->entries->{$sample})) {
    $entry->increment_frequency;
    $entry->num_allowed_errors($self->current_bucket - 1);
  } else {
    $self->entries->{$sample} = Algorithm::LossyCount::Entry->new(
      num_allowed_errors => $self->current_bucket - 1,
    )
  }

  ++$self->{num_samples};
  ++$self->{num_samples_in_current_bucket};
  $self->clear_bucket if $self->bucket_is_full;
}

sub bucket_is_full {
  my ($self) = @_;

  $self->num_samples_in_current_bucket >= $self->bucket_size;
}

sub bucket_size { $_[0]->{bucket_size} }

sub clear_bucket {
  my ($self) = @_;

  for my $sample (keys %{ $self->entries }) {
    my $entry = $self->entries->{$sample};
    unless ($entry->survive_in_bucket($self->current_bucket)) {
      delete $self->entries->{$sample};
    }
  }
  ++$self->{current_bucket};
  $self->{num_samples_in_current_bucket} = 0;
}

sub current_bucket { $_[0]->{current_bucket} }

sub entries { $_[0]->{entries} }

sub frequencies {
  my ($self, %params) = @_;

  my $support = delete $params{support} // 0;
  if (%params) {
    Carp::croak(
      'Unknown parameter(s): ',
      join ', ', map { qq/"$_"/ } sort keys %params,
    )
  }

  my $threshold = ($support - $self->max_error_ratio) * $self->num_samples;
  my %frequencies = map {
    my $frequency = $self->entries->{$_}->frequency;
    $frequency < $threshold ? () : ($_ => $frequency);
  } keys %{ $self->entries };
  return \%frequencies;
}

sub max_error_ratio { $_[0]->{max_error_ratio} }

sub num_samples { $_[0]->{num_samples} }

sub num_samples_in_current_bucket { $_[0]->{num_samples_in_current_bucket} }

1;
