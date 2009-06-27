package IM::Engine::HasPlugins;
use Moose::Role;

use IM::Engine::Plugin;

has _plugins => (
    metaclass => 'Collection::List',
    isa       => 'ArrayRef[IM::Engine::Plugin]',
    init_arg  => 'plugins',
    provides  => {
        elements => 'plugins',
        grep     => 'find_plugins',
    },
);

sub plugins_with {
    my $self = shift;
    my $role = shift;

    $role = "IM::Engine::Plugin::$role"
        unless $role =~ s/^\+//;

    return $self->find_plugins(sub { $_->does($role) });
}

sub plugin_relay {
    my $self = shift;
    my %args = @_;

    my $role   = $args{role};
    my $method = $args{method};
    my $baton  = $args{baton};

    for my $plugin ($self->plugins_with($role)) {
        $baton = $plugin->$method($baton);
    }

    return $baton;
}

1;

