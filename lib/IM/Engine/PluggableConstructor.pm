package IM::Engine::PluggableConstructor;
use MooseX::Role::Parameterized;
with 'MooseX::Traits';

parameter does_role => (
    isa      => 'RoleName',
    does     => 'IM::Engine::ExtendsObject',
    required => 1,
);

role {
    my $p = shift;

    method new_with_plugins => sub {
        my $class = shift;

        my %args = (
            $class->plugin_collect(
                role   => $p->does_role,
                method => 'constructor_arguments',
            ),
            @_,
        );

        push @{ $args{traits} || [] }, $class->plugin_collect(
            role   => $p->does_role,
            method => 'traits',
        );

        $class->new_with_traits(\%args);
    };
};

1;

