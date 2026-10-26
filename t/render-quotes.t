# render-quotes.t
use strict;
use warnings;
use Test::More tests => 2;

use Text::TinyTemplate;

my $tt = Text::TinyTemplate->new;

# ダブルクォートを使ったハッシュキーアクセス
is(
    $tt->render('<%= $user->{"name"} %>', { user => { name => 'Bob' } }),
    'Bob',
    'double quotes inside expression'
);

# q() を使った文字列リテラル
is(
    $tt->render('<%= q(hello) %>', {}),
    'hello',
    'q() operator inside expression'
);
