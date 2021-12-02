package Shortr::Model::DB::Url;
use Mojo::Base 'Shortr::Model::DB', -signatures;
use MIME::Base64;
use Data::Dumper;

# Class variables. db_fields is a required field for DB Models. 
has 'db_fields' => sub { return ['url_id', 'token', 'destination_url', 'destination_url_hash', 'date_created', 'date_updated'] };
has 'url_id';
has 'token';
has 'destination_url';
has 'destination_url_hash';
has 'date_created';
has 'date_updated';

# Look in the database for the URL record for the given token
sub get_by_token ($self, $token) {
    $self->app->log->debug("in get_by_token. token: $token");
    return $self->_get_by_field('token', $token);
}

# Look in the database for the URL record for the given destination_hash
sub get_by_hash ($self, $hash_key) {
    $self->app->log->debug("in get_by_hash. hash: $hash_key");
    return $self->_get_by_field('destination_url_hash', $hash_key);
}

# Incoming hash reference needs to have db fields as keys. The fields must match up to what is in the database or else
# they will be ignored
sub insert ($self, $href) {
    # Validation - Make sure that the keys in the incomgin hash are acual database fields
    my $params = {};
    foreach my $field (@{ $self->db_fields }) {
        next unless $href->{$field};
        $params->{$field} = $href->{$field};
    }
    return $self->mysql->db->insert('urls', $params)->last_insert_id;
}

# Creates a new 
sub generate ($self, $dest_url, $hash_key) {
    $self->app->log->info("generate: dest_url: $dest_url");

    # The tokens are based off of url_id. Therefore, insert into the database first to get the id
    my $new_url_id = $self->mysql->db->insert(
        'urls',
        { destination_url      => $dest_url, 
          destination_url_hash => $hash_key }
    )->last_insert_id;

    # Now, generate the token using the last inserted database id as the input
    my $new_token = $self->encode_base62($new_url_id);
    $self->app->log->debug("-> generate: new_url_id=$new_url_id, new_token: $new_token");

    # Laslty, store the token into the database
    my $ret = $self->mysql->db->update(
        'urls',
        { token  => $new_token },
        { url_id => $new_url_id }
    );
    return $self->get_by_hash($hash_key);
}

# generates the token. 
sub encode_base62 ($self, $num) {
    my $primitives = join( '', 0 .. 9, 'a' .. 'z', 'A' .. 'Z' );
    my @c;
    do {
        push( @c, substr( $primitives , $num % length($primitives), 1 ) );
        $num = int( $num / length($primitives) );
    } while( $num );
    join( '', reverse @c );
}
1;
__END__

=pod

=head1 NAME

Shortr::Model::DB::Url

=head1 DESCRIPTION

Model calss for the URLs table. 

=head1 METHODS

=head2 get_by_token

Given a token, looks up the URL. This is typically used when trying to find the destination URL

=head2 get_by_hash

Given a MD5 hash of an incoming URL, try to find the URL record. This is typically used when inserting
a new record into the database. The goal is to look to see if a URL is duplicated. If yes, then return
the same token

=head2 insert

Inserts data into the URLs table

=head2 generate

Does the work of generating a new token. This is accomplished by first inserting data into the database.
This allows us to get the auto incrementing ID. The token is based off of the ID. Once the token is 
generated, update the database with the new token value

=head2 encode_base62

This is the method that generates the token 

=head1 AUTHOR

Nicholas McCamey

=cut
