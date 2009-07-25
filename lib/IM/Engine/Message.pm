package IM::Engine::Message;
use Moose;
with 'MooseX::Traits';

has message => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has plaintext => (
    is       => 'ro',
    isa      => 'Str',
    lazy     => 1,
    builder  => '_build_plaintext',
);

sub _build_plaintext { shift->message }

__PACKAGE__->meta->make_immutable;
no Moose;

1;
