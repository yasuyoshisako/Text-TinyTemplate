package Text::TinyTemplate::Utils;

use 5.008;
use strict;
use warnings;

our $VERSION = '0.02';

my %HTML = ( '&' => '&amp;', '<' => '&lt;', '>' => '&gt;', '"' => '&quot;', "'" => '&#39;' );
my $escaped_keys = quotemeta join('', keys %HTML);

sub escape_html {

  my $str = shift;
  return unless defined $str;

  $str =~ s/([$escaped_keys])/$HTML{$1}/ge;
  $str;
}

sub make_accessors {
  
  my $package = caller;

  {
    no strict 'refs';
    for my $field (@_) {
      *{"${package}::${field}"} = sub {
        my $self = shift;
        $self->{$field} = shift if @_;
        $self->{$field};
      };
    }
  }
}

sub import {

  my $self = shift;
  my $package = caller;

  {
    no strict 'refs';
    *{"${package}::$_"} = \&{"${self}::$_"} for @_;
  }
}

1;

=encoding utf8

=head1 NAME

Text::TinyTemplate::Utils - Utility functions for Text::TinyTemplate.

=head1 VERSION

Version 0.02

=head1 SYNOPSIS

    package Text::TinyTemplate;
    use strict;
    use warnings;

    use Text::TinyTemplate::Utils qw( escape_html make_accessors );

    # HTML escaping
    my $safe_text = escape_html($raw_text);

    # Generating getter/setter accessors
    make_accessors( qw( tag_start tag_end expression_mark ) );

=head1 DESCRIPTION

C<Text::TinyTemplate::Utils> provides internal utility functions used by C<Text::TinyTemplate>. 
These functions can be imported explicitly as needed.

=head1 FUNCTIONS

The following functions can be exported on demand:

=head2 escape_html($text)

Escapes special characters in the given C<$text> to prevent HTML injection (XSS).

    my $safe = escape_html('<script>alert("XSS");</script>');
    # Result: &lt;script&gt;alert(&quot;XSS&quot;);&lt;/script&gt;

Characters handled:
=over 4
=item * C<&> becomes C<&amp;>
=item * C<"> becomes C<&quot;>
=item * C<'> becomes C<&#39;>
=item * C<< < >> becomes C<&lt;>
=item * C<< > >> becomes C<&gt;>
=back

=head2 make_accessors(@attribute_names)

Dynamically generates getter/setter methods for the calling package (class).

    make_accessors('foo', 'bar');

This creates C<foo()> and C<bar()> methods in the caller's namespace, allowing objects to get or set their attribute values:

    $obj->foo('new_value'); # setter
    my $val = $obj->foo;    # getter

=head1 SEE ALSO

L<Text::TinyTemplate>

=head1 AUTHOR

Yasuyoshi Sako

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut