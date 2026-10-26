# render-basic.t

use strict;
use warnings;
use Test::More tests => 5;

use Text::TinyTemplate;

my $tt = Text::TinyTemplate->new;

is(
    $tt->render('<%= 1 + 2 %>', {}),
    '3',
    'simple expression'
);

is(
    $tt->render('<%= $name %>', { name => 'Alice' }),
    'Alice',
    'variable expansion'
);

is(
    $tt->render('<% foreach my $x (@$list) { %><%= $x %> <% } %>', { list => [1, 2, 3] }),
    '1 2 3 ',
    'foreach loop'
);

use Text::TinyTemplate::Utils qw( escape_html );
is(
    $tt->render('<%= escape_html($x) %>', { x => '<tag>' }),
    '&lt;tag&gt;',
    'escape_html works inside template'
);

my $tt2 = Text::TinyTemplate->new;

$tt2->tag_start('[%');
$tt2->tag_end('%]');

is(
    $tt2->render('[%= 10 %]', {}),
    '10',
    'custom tag delimiters'
);
