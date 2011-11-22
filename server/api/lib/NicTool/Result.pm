package NicTool::Result;

=head1 NAME

NicTool::Result - The result of a NicTool API function call.

=head1 SYNOPSIS

All NicTool API function calls return an instance of this class or of a
subclass.

    my $res = $nt->delete_users(user_list=>"12");

=head1 DESCRIPTION

Every type of object used to represent an object from the NicTool 
system is represented by a subclass of B<NicTool::Result>.  This class
provides a simple mechanism for checking whether the result was an
error and what the error code and message are.

=cut

use strict;
use NicTool::NTObject;

our @ISA = qw(NicTool::NTObject);

=head1 METHODS

=over

=item new(PARAMS)

Creates a new B<NicTool::Result> object.  Unless 'error_code' and 
'error_msg' are specified, they default to '200' and 'OK' respectively.

=cut

sub new {
    my ( $pkg, $nt, @rest ) = @_;
    my $self = $pkg->SUPER::new(@rest);
    $self->set( 'error_code', '200' ) unless $self->has('error_code');
    $self->set( 'error_msg',  'OK' )  unless $self->has('error_msg');
    $self->set( 'error_desc', '' )    unless $self->has('error_desc');
    my $type = $pkg;
    $type =~ s/.*:://;
    $self->{type} = $type;
    $self->{nt}   = $nt;
    $self = bless $self, $pkg;
    $self->_init;
    return $self;
}

sub _init { }

=item error_code

Returns the error code of the result.

=cut

sub error_code {
    return $_[0]->get('error_code');
}

=item error_msg

Returns the error message of the result.

=cut

sub error_msg {
    return $_[0]->get('error_msg');
}

=item error_desc

Returns the error description of the result.

=cut

sub error_desc {
    return $_[0]->get('error_desc');
}

=item errstr

Returns a string describing the entire error.

=cut

sub errstr {
    return
          $_[0]->error_code . ":("
        . $_[0]->error_desc . ") "
        . $_[0]->error_msg;
}

=item warn_if_err

Warns of an error if the result is an error.
Returns false if not an error.

=cut

sub warn_if_err {

    if ( $_[0]->is_error ) {
        warn $_[0]->errstr;
        return 1;
    }
    else {
        return 0;
    }
}

=item die_if_err

Dies of an error if the result is an error.
Returns false if not an error.

=cut

sub die_if_err {

    if ( $_[0]->is_error ) {
        die $_[0]->errstr;
        return 1;
    }
    else {
        return 0;
    }
}

=item is_error

Returns true if the error code is not '200'.

=cut

sub is_error {
    return ( $_[0]->error_code != 200 );
}

=pod

=back

=head1 SUPERCLASS

=over

=item *

L<NicTool::NTObject>

=back

=head1 KNOWN SUBCLASSES

=over

=item *

L<NicTool::DBObject>

=item *

L<NicTool::List>

=back

=head1 AUTHORS

=over 4

=item *

Matt Simerson <msimerson@cpan.org>

=item *

Damon Edwards

=item *

Abe Shelton

=item *

Greg Schueler

=back

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2011 by The Network People, Inc. This software is Copyright (c) 2001 by Damon Edwards, Abe Shelton, Greg Schueler.

This is free software, licensed under:

  The GNU Affero General Public License, Version 3, November 2007

=cut

1;
