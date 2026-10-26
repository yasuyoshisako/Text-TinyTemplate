# escape_html.t

use strict;
use warnings;
use Test::More tests => 6;

use Text::TinyTemplate::Utils qw( escape_html );

# 基本のエスケープ
is( escape_html('<'), '&lt;', 'escape <' );
is( escape_html('>'), '&gt;', 'escape >' );
is( escape_html('&'), '&amp;', 'escape &' );
is( escape_html('"'), '&quot;', 'escape "' );
is( escape_html("'"), '&#39;', "escape '" );

# undef は undef を返す
is( escape_html(undef), undef, 'undef returns undef' );
