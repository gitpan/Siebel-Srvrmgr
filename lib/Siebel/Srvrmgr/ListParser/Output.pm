package Siebel::Srvrmgr::ListParser::Output;

=pod

=head1 NAME

Siebel::Srvrmgr::ListParser::Output - base class of srvrmgr output

=head1 SYNOPSIS

	use Siebel::Srvrmgr::ListParser::Output;

	my $output = Siebel::Srvrmgr::ListParser::Output->new({ data_type => 'sometype', 
															raw_data => \@data, 
															cmd_line => 'list something from somewhere'});

	$output->store($complete_pathname);

=cut

use Moose;

use MooseX::Storage;
use namespace::autoclean;
use Carp;
use Siebel::Srvrmgr::Regexes qw(ROWS_RETURNED);

with Storage( io => 'StorableFile' );

=pod

=head1 DESCRIPTION

Siebel::Srvrmgr::ListParser::Output is a superclass of output types classes.

It contains only basic attributes and methods that enable specific parsing and serializable methods.

The C<parse> method must be overrided by subclasses or a exception will be raised during object creation.

=head1 ATTRIBUTES

=head2 data_type

Identifies which kind of data is being given to the class. This is usually used by abstract factory classes to identify which subclass of 
Siebel::Srvrmgr::ListParser::Output must be created.

This attribute is required during object creation.

=cut

has 'data_type' =>
  ( is => 'ro', isa => 'Str', reader => 'get_data_type', required => 1 );

=pod

=head2 raw_data

An array reference with the lines to be processed.

This attribute is required during object creation.

=cut

has 'raw_data' => (
    is       => 'rw',
    isa      => 'ArrayRef',
    reader   => 'get_raw_data',
    writer   => 'set_raw_data',
    required => 1

);

=pod

=head2 data_parsed

An hash reference with the data parsed from C<raw_data> attribute.

=cut

# :TODO:08-10-2013:arfreitas: verify if it is possible to reduce memory usage by removing data_parsed in some class
# that don't use it directly

has 'data_parsed' => (
    is     => 'rw',
    isa    => 'HashRef',
    reader => 'get_data_parsed',
    writer => 'set_data_parsed'
);

=pod

=head2 cmd_line

A string of the command that originates from the output (the data of C<raw_data> attribute).

This attribute is required during object creation.

=cut

has 'cmd_line' =>
  ( isa => 'Str', is => 'ro', reader => 'get_cmd_line', required => 1 );

=pod

=head2 clear_raw

=cut

has 'clear_raw' => (
    is      => 'rw',
    isa     => 'Bool',
    reader  => 'clear_raw',
    writer  => 'set_clear_raw',
    default => 0
);

=pod

=head1 METHODS

=head2 clear_raw

=head2 set_clear_raw

=head2 get_cmd_line

Returns an string of the attribute C<get_cmd_line>.

=head2 get_data_parsed

Retuns an hash reference of C<data_parsed> attribute.

=head2 set_data_parsed

Sets the C<data_parsed> attribute. It is expected an hash reference as parameter of the method.

=head2 get_raw_data

Returns an array reference of the attribute C<raw_data>.

=head2 set_raw_data

Sets the C<raw_data> attribute. An array reference is expected as parameter of the method.

=head2 load

Method inherited from L<MooseX::Storage::IO::StorableFile> role. It loads a previously serialized Siebel::Srvrmgr::ListParser:Output object into memory.

=head2 store

Method inherited from L<MooseX::Storage::IO::StorableFile> role. It stores (serializes) a Siebel::Srvrmgr::ListParser:Output object into a file. A a string of the filename 
(with complete or not full path) is expected as a parameter.

=head2 BUILD

All subclasses of Siebel::Srvrmgr::ListParser::Object will call the method C<parse> right after object instatiation.

=cut

sub BUILD {

    my $self = shift;

    $self->parse();

}

=pod

=head2 parse

This method must be overrided by subclasses.

=cut

sub parse {

    confess
'parse method must be overrided by subclasses of Siebel::Srvrmgr::ListParser::Output';

}

=pod

=head1 SEE ALSO

=over 4 

=item *

L<Moose>

=item *

L<MooseX::Storage>

=item *

L<MooseX::Storage::IO::StorableFile>

=item *

L<namespace::autoclean>

=back

=head1 AUTHOR

Alceu Rodrigues de Freitas Junior, E<lt>arfreitas@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 of Alceu Rodrigues de Freitas Junior, E<lt>arfreitas@cpan.orgE<gt>.

This file is part of Siebel Monitoring Tools.

Siebel Monitoring Tools is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Siebel Monitoring Tools is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Siebel Monitoring Tools.  If not, see L<http://www.gnu.org/licenses/>.

=cut

no Moose;
__PACKAGE__->meta->make_immutable;

1;
