# render-utf8.t
use strict;
use warnings;
use utf8; # テストコード自体の文字コードをUTF-8にする
use Test::More tests => 2;
use Encode qw( decode encode );

use Text::TinyTemplate;

my $tt = Text::TinyTemplate->new;

my $template = decode('UTF-8', 'こんにちは、<%= $name %>さん！');
my $data     = { name => decode('UTF-8', '田中') };

my $output = $tt->render($template, $data);

is(
    $output,
    decode('UTF-8', 'こんにちは、田中さん！'),
    'multibyte string rendering'
);

# 出力時のエンコード確認
is(
    encode('UTF-8', $output),
    'こんにちは、田中さん！',
    'multibyte string encoding for output'
);
