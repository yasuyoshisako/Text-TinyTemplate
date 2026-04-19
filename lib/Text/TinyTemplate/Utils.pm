package Text::TinyTemplate::Utils;

use 5.008;
use strict;
use warnings;

use Carp qw( croak );

our $VERSION = '0.01';

my %escape_rules = ( '&' => 'amp', '>' => 'gt', '<' => 'lt', '"' => 'quot', "'" => '#39' );

sub escape_html {

  my $str = shift;
  my $extra_rules = shift;
  return unless defined $str;

  my %rules = %escape_rules;
  if (defined $extra_rules) {
    if (ref($extra_rules) eq 'HASH') {
      while (my ($key, $value) = each %$extra_rules) {
        $rules{$key} = $value;
      }
    }
    else {
      croak 'The second argument of escape_html must be a hash reference.';
    }
  }

  my $escape_keys = '[' . join('', keys %rules) . ']';

  $str =~ s/(&[a-zA-Z0-9]+;|&#\d+;|&#x[0-9a-fA-F]+;)|($escape_keys)/$1 ? $1 : '&' . $rules{$2} . ';'/ge;
  $str;

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

Version 0.01

=head1 SYNOPSIS

  use Text::TinyTemplate::Utils qw( escape_html );

  my $escaped = escape_html('<script>alert(1)</script>');
  # &lt;script&gt;alert(1)&lt;/script&gt;

  # Add custom escape rules
  my $escaped2 = escape_html('<>', { '<' => 'foo' });
  # &foo;&gt;

=head1 DESCRIPTION

This module provides utility functions used internally by L<Text::TinyTemplate>.
Currently it contains only one function, C<escape_html>, which performs minimal HTML escaping.

The implementation is intentionally small and dependency-free, following the same "Tiny" philosophy as L<Text::TinyTemplate>.

=head1 FUNCTIONS

=head2 escape_html($string, \%extra_rules)

  my $escaped = escape_html($string);
  my $escaped = escape_html($string, { '<' => 'lt2' });

Escapes unsafe HTML characters in C<$string> and returns the escaped result.
The following characters are escaped by default:

  &  <  >  "  '

These are converted to:

  &amp;  &lt;  &gt;  &quot;  &#39;

If C<\%extra_rules> is provided, its keys and values are merged into the default escape rules.  Extra rules override the defaults.

  escape_html('<', { '<' => 'foo' });  # &foo;

Existing HTML entities such as C<&amp;>, C<&#123;>, and C<&#x1f;> are preserved and not double-escaped.

=head1 EXPORTS

This module does not export anything by default.  
Functions must be imported explicitly:

  use Text::TinyTemplate::Utils qw( escape_html );

=head1 SEE ALSO

L<Text::TinyTemplate>

=head1 AUTHOR

Yasuyoshi Sako

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
