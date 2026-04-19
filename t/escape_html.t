use strict;
use warnings;
use Test::More tests => 8;

use Text::TinyTemplate::Utils qw( escape_html );

# 基本のエスケープ
is( escape_html('<'), '&lt;', 'escape <' );
is( escape_html('>'), '&gt;', 'escape >' );
is( escape_html('&'), '&amp;', 'escape &' );
is( escape_html('"'), '&quot;', 'escape "' );
is( escape_html("'"), '&#39;', "escape '" );

# HTML エンティティはそのまま
is( escape_html('&amp;'), '&amp;', 'existing entity preserved' );

# 追加ルール
is( escape_html('<', { '<' => 'foo' }), '&foo;', 'custom rule overrides default' );

# undef は undef を返す
is( escape_html(undef), undef, 'undef returns undef' );
