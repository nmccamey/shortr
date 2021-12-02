package Shortr::Controller::URL;
use Mojo::Base 'Mojolicious::Controller', -signatures;
use Digest::MD5 qw(md5_base64);
use Data::Validate::URI qw(is_http_uri is_https_uri);

sub find_or_create ($self) {
    $self->log->debug("In find_or_create");

    # validate parameters
    my $input_url = $self->param('inputUrl');
    unless( $input_url ) {
        $self->log->info("find_or_create: Missing inputUrl parameter");
        self->render(json => { status => 'fail', message => 'required parameter input url is missing', dest_url => $input_url});
    }

    $self->log->debug("find_or_create: input_url=$input_url");
    unless( $self->_validate_url($input_url) ) {
        $self->log->info("find_or_create: input_url is not valid");
        $self->render(json => { status => 'fail', message => 'input URL did not pass validation', dest_url => $input_url });
        return;
    }

    # Convert the input url to a MD5 hash for looking up in the database
    my $md5 = md5_base64($input_url);
    $self->log->debug("-> md5: $md5");
    my $url = $self->app->db('url')->get_by_hash( md5_base64($input_url) );

    if( !$url ) {
        $self->app->log->debug("find_or_create: generating a new short url for $input_url");
        $url = $self->app->db('url')->generate($input_url, $md5);
    }

    $self->render(json => {
        status    => 'success',
        token     => $url->token,
        dest_url  => $url->destination_url,
        short_url => $self->app->_build_url( $url->token )
    });
}

sub _validate_url ($self, $url) {
    $self->log->debug("in _validate_url with $url");
    return is_https_uri($url) || is_http_uri($url);
}

1;

__END__

=pod

=head1 NAME

Shortr::Controller::Home

=head1 DESCRIPTION

Controller that is used to manipulate the URL objects. These calls will only return JSON data

=head1 METHODS

=head2 find_or_create

Given a destination URL, returns the token. This method handles generating new rows and tokens for the database. If
the passed in URL exists, the existing token will be returned. Otherwise, create a new one

=head1 SEE ALSO

L<https://docs.mojolicious.org/Mojolicious/Controller>

=head1 AUTHOR

Nicholas McCamey

=cut
