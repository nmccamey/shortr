package Shortr;
use Mojo::Base 'Mojolicious', -signatures;

use Data::Dumper;
use DBI;

# This method will run once at server start
sub startup ($self) {

    # Load configuration from config file
    my $config = $self->plugin('NotYAMLConfig');

    # Database configuration
    my ($db_name, $db_password, $db_user) = @{$config->{database}}{'MYSQL_DATABASE', 'MYSQL_USER', 'MYSQL_PASSWORD'};
    $self->plugin('Model::DB' => { mysql => "mysql://$db_password:$db_user\@mysqldb/$db_name" });

    # Configure the application
    $self->secrets($config->{secrets});

    # Router
    my $r = $self->routes;

    ### Home Page Section - Any addtional pages for the site should be added here
    $r->get('/')->to('Home#index');

    ### Redirect Section - Look up the given shortened URL and redirect the user to the translated URL
    $r->get('/:token')->to('Home#redirect');

    ### API Section - Enter routes for the API below. 
    $r->post('/api/url')->to('URL#find_or_create');
}

sub _build_url ($self, $token) { return "http://localhost:3001/$token" }

1;
__END__

=pod

=head1 NAME

Shortr

=head1 DESCRIPTION

This is the base package for the Shortr web service. This class gets everything configured and 
prepared to respond to incoming requests

=head1 METHODS

=head2 startup

Required method for all Mojolicious applications. This gets executed when the server starts and
handles setting up the configuration and routing

=head2 _build_url

Constructs a shortened URL. This is needed to be able to define the URL of the current application.

=head1 SEE ALSO

L<https://mojolicious.org/>

L<https://metacpan.org/pod/Mojolicious>

L<https://github.com/mojolicious/mojo>

=head1 AUTHOR

Nicholas McCamey

=cut
