# render-utf8.t
use strict;
use warnings;
use utf8; # テストコード自体の文字コードをUTF-8にする
use Test::More tests => 2;
use Encode qw( decode encode );

use Text::TinyTemplate;

my $tt = Text::TinyTemplate->new;

# 外部からの入力（バイト列）を模倣するため、一度エンコードしてからデコードする
my $template = decode('UTF-8', encode('UTF-8', 'こんにちは、<%= $name %>さん！'));
my $data     = { name => decode('UTF-8', encode('UTF-8', '田中')) };

my $output = $tt->render($template, $data);

# 1. テンプレート展開後の文字列が正しくデコード（内部フラグ付き）されているか
# 比較側は use utf8; により自動的にフラグ付き文字列になるため、そのまま比較できる
is(
    $output,
    'こんにちは、田中さん！',
    'multibyte string rendering'
);

# 2. 出力時のエンコード確認（バイト列に戻して比較）
is(
    encode('UTF-8', $output),
    encode('UTF-8', 'こんにちは、田中さん！'),
    'multibyte string encoding for output'
);
