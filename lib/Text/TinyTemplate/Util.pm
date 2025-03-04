package Text::TinyTemplate::Util;

use strict;
use warnings;

our $VERSION = '0.01';

# https://dankogai.livedoor.blog/archives/50940023.htmlを引用
my %escape_rule = ( '&' => 'amp', '>' => 'gt', '<' => 'lt', '"' => 'quot', "'" => '#39' );
my $escape_keys = '[' . join('', keys %escape_rule) . ']';

sub escape_html {

  my $str = shift;
  return unless defined $str;

  $str =~ s/($escape_keys)(?!amp;)/'&' . $escape_rule{$1} . ';'/ge;
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

Text::TinyTemplate::Util - Utility functions for Text::TinyTemplate.

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

  <%= escape_html(string) %>

=head1 DESCRIPTION

C<Text::TinyTemplate::Util> provides utility functions for C<Text::TinyTemplate>.

=head1 FUNCTIONS

=head2 escape_html

Escape unsafe characters E<amp>, E<lt>, E<gt>, and E<quot> in string.

=head1 AUTHOR

Yasuyoshi Sako (yasuyoshi.sako@gmail.com)

=cut
