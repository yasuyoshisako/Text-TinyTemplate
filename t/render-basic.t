use strict;
use warnings;
use Test::More tests => 5;

use Text::TinyTemplate;

my $tt = Text::TinyTemplate->new;

# 1. 単純な式
is(
    $tt->render('<%= 1 + 2 %>', {}),
    '3',
    'simple expression'
);

# 2. 変数展開
is(
    $tt->render('<%= $name %>', { name => 'Alice' }),
    'Alice',
    'variable expansion'
);

# 3. 繰り返し
my $tpl = <<'EOF';
<% foreach my $x (@$list) { %><%= $x %> <% } %>
EOF

is(
    $tt->render($tpl, { list => [1, 2, 3] }) =~ s/\s+\z//r,
    '1 2 3',
    'foreach loop'
);

# 4. HTML エスケープ（ユーザーが Utils を使う場合）
use Text::TinyTemplate::Utils qw( escape_html );
is(
    $tt->render('<%= escape_html($x) %>', { x => '<tag>' }),
    '&lt;tag&gt;',
    'escape_html works inside template'
);

# 5. カスタムタグ
my $tt2 = Text::TinyTemplate->new;

$tt2->tag_start('[%');
$tt2->tag_end('%]');

is(
    $tt2->render('[%= 10 %]', {}),
    '10',
    'custom tag delimiters'
);
