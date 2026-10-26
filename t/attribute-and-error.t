# attribute-and-error.t
use strict;
use warnings;
use Test::More tests => 3;

use Text::TinyTemplate;

my $tt = Text::TinyTemplate->new;

# 属性のゲッター・セッターテスト
$tt->tag_start('{{');
is($tt->tag_start, '{{', 'tag_start getter/setter');

$tt->tag_end('}}');
is($tt->tag_end, '}}', 'tag_end getter/setter');

# 不正なPerlコードが含まれている場合にcroakするか
eval {
    $tt->render('<%= $undefined_variable_strict_mode_check_or_syntax_error %>', {});
};
like($@, qr/^Template error:/, 'croak on template evaluation error');
