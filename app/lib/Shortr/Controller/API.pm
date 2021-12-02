package Shortr::Controller::API;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# This action will render a template
sub url ($self) {

    my $dbh = $self->db;
    my $token = encode_base62('https://www.google.com');
    my $return = {
    };
    $self->render(json => {foo => [1, 'test', 3]});
}

use constant PRIMITIVES => join( '', 0 .. 9, 'a' .. 'z', 'A' .. 'Z' );

sub encode_base62 {
    my( $num ) = @_;
    my @c;
    do {
	      push( @c, substr( PRIMITIVES, $num % length(PRIMITIVES), 1 ) );
	      $num = int( $num / length(PRIMITIVES) );
    } while( $num );
    join( '', reverse @c );
}

1;
