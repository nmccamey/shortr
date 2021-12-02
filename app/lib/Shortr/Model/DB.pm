package Shortr::Model::DB;
use Mojo::Base 'MojoX::Model', -signatures;

has 'db_fields' => sub { die "Implement in child classes"};

sub _store_results ($self, $href) {
    map { $self->$_($href->{$_}) } @{$self->db_fields};
    return $self;
}
 
sub _get_by_field ($self, $field, $value) {
    my $href = $self->mysql->db->select( 'urls', $self->db_fields, { $field => $value})->hash;
    return $self->_store_results( $href ) if $href;
    $self->app->log->debug("-> Unale to find $value using $field");
    return undef;
}

1;
__END__

=pod

=head1 NAME

Shortr::Model::DB

=head1 DESCRIPTION

Base Model class for any objects that need to interact with the database. Each Model class will
have class attributes that represent the data in the database. Each also needs an array of database
fields to be defined

=head1 METHODS

=head2 _store_results

Helper method that copies data from a hash (typically from a database lookup) into the object

=head2 _get_by_field

Helper method that runs a select statement. Cuts down on duplicated code from several fucntions that 
are running select statemetns

=head1 AUTHOR

Nicholas McCamey

=cut
