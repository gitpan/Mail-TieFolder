package Mail::TieFolder;

require 5.005_62;
use strict;
use warnings;
use vars qw(@ISA);

require Exporter;
use AutoLoader qw(AUTOLOAD);

@ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use Mail::TieFolder ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
	
);
our $VERSION = '0.01';


=head1 NAME

Mail::TieFolder - Tied hash interface for mail folders 

=head1 SYNOPSIS

  use Mail::TieFolder;

  # assuming inbox is an MH folder, and the 
  # Mail::TieFolder::mh module is installed:
  tie (%inbox, 'Mail::TieFolder', 'mh', 'inbox');

  # get list of all message IDs in folder
  @messageIDs = keys (%inbox);

  # fetch message by ID 
  $msg = $inbox{'9287342.2138749@foo.com'};

=head1 DESCRIPTION

Mail::TieFolder implements a tied hash interface for various mail
folder formats.  See the Mail::TieFolder::* modules on CPAN for
supported formats.

=cut

sub TIEHASH
{
  my $class = shift;
  my $format = shift;
  my @args = @_;

  my $self={};
  bless $self, $class;

  my $module = $class . "::$format";
  eval "use $module";
  push @ISA, $module;

  return $self->SUPER::TIEHASH(@args);
}

sub supported
{
  my $class = ref(shift) if ref($_[0]);
  $class = "Mail::TieFolder" unless $class;
  my $relpath = $class;
  $relpath =~ s/::/\//g;
  my $format = shift;

  if ($format)
  {
    # is it supported?
    my $module = $class . "::$format";
    return eval "require $module";
  }
  else
  {
    # find all supported
    my @supported;
    for (@INC)
    {
      my $dir="$_/$relpath";
      opendir(DIR,$dir);
      for(readdir(DIR))
      {
	next unless /^(\w+).pm$/;
	push @supported, $1;
      }
    }
    return @supported;
  }
}

=head1 AUTHOR

Steve Traugott, stevegt@TerraLuna.Org

=head1 SEE ALSO

perltie(1)

=cut

1;
__END__

