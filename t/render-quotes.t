# render-quotes.t
use strict;
use warnings;
use Test::More tests => 2;

use Text::TinyTemplate;

my $tt = Text::TinyTemplate->new;

is(
    $tt->render('<%= $user->{"name"} %>', { user => { name => 'Bob' } }),
    'Bob',
    'double quotes inside expression'
);

is(
    $tt->render('<%= q(hello) %>', {}),
    'hello',
    'q() operator inside expression'
);
