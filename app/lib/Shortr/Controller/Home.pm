package Shortr::Controller::Home;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# No logic needed for this one
sub index ($self) {
  $self->render;
}

sub redirect ($self) {
    my $token = $self->stash->{token};
    $self->app->log->debug("In redirect. Looking for $token");
    my $url = $self->app->db('url')->get_by_token($token);
    if( $url ) {
        $self->log->debug("redirecting to " . $url->destination_url);
        $self->redirect_to($url->destination_url);
        return;
    }
    return $self->reply->not_found;
}

1;

__END__

=pod

=head1 NAME

Shortr::Controller::Home

=head1 DESCRIPTION

Controller for the routes that handle the HTML pages. This includes the main page to get URLs as well as the redirect page

=head1 METHODS

=head2 index

Just here to serve up the HTML for the main page.

=head2 redirect

Takes in a token from the URL and tries to match it to one in the database. If found, send a redirect message to the caller 
to the URL in the database. If the token is not found, the 404 page will be displayed

=head1 SEE ALSO

L<https://docs.mojolicious.org/Mojo/Base>

=head1 AUTHOR

Nicholas McCamey

=cut
