package Text::TinyTemplate;

use 5.008;
use strict;
use warnings;

use Carp qw( croak );
use Text::TinyTemplate::Utils qw( escape_html );

our $VERSION = '0.01';

sub new {

  my $class = shift;

  my $self =  {
    tag_start       => '<%',
    tag_end         => '%>',
    expression_mark => '=',
  };

  bless $self, ref $class || $class;

  return $self;

}

sub render {

  my ($self, $template, $data) = @_;

  my $start = $self->tag_start;
  my $end   = $self->tag_end;
  my $expr  = $self->expression_mark;

  # if (-e $template) {
  #
  #   $template = do {
  #     open my $fh, '<', $template or croak "Can't open template file: $template";
  #     local $/;
  #     <$fh>;
  #   };
  # }

  return do {

    my @vals = grep { /^\w+$/ } keys %$data;
    my $args = @vals ? 'my (' . join(',', map { "\$$_" } @vals) . ')'
                       . ' = @{ $data }{qw(' . join(' ', @vals) . ')};'
                     : '';
    
    $template =~ s/(\s*)\Q$start\E(\Q$expr\E)?\s*(.+?)\s*\Q$end\E(\s*)/
      $2 ? $1 . q('; $_0 .= ) . $3 . q(; $_0 .= ') . $4
         : q('; ) . $3 . q( $_0 .= ') . $4 /ge;

    my $code = "#line 1 \"template\"\n$args\n" . q(my $_0 = ') . $template . q('; $_0;);
    my $result = eval $code;
    if ($@) {
      my $err = $@;
      $err =~ s/\(eval \d+\)/template/;
      croak "Template error: $err";
    }

    return $result;

  };

}

sub tag_end {

  my $self = shift;

  $self->{'tag_end'} = $_[0] if @_;
  $self->{'tag_end'};

}

sub tag_start {

  my $self = shift;

  $self->{'tag_start'} = $_[0] if @_;
  $self->{'tag_start'};

}

sub expression_mark {

  my $self = shift;

  $self->{'expression_mark'} = $_[0] if @_;
  $self->{'expression_mark'};

}

1;

=encoding utf8

=head1 NAME

Text::TinyTemplate - A minimalistic template engine inspired by Mojo::Template.

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

  use Text::TinyTemplate;

  my $template = do { local $/; <DATA> };
  my $data = {
    title  => 'Name list',
    people => [
      { name => 'Smith', age => 42 },
      { name => 'John',  age => 37 },
      { name => 'Lewis', age => 28 },
    ],
  };

  my $tt = Text::TinyTemplate->new;
  my $output = $tt->render($template, $data);

  print $output;

  __DATA__
  <html>
    <head>
      <title><%= $title %></title>
    </head>
    <body>
      <h1><%= $title %></h1>
      <ul>
      <% foreach my $person (@$people) { %>
        <li><%= $person->{name} %> : <%= $person->{age} %> years old</li>
      <% } %>
      </ul>
    </body>
  </html>

=head1 DESCRIPTION

C<Text::TinyTemplate> is a very small and simple template engine.
It was created with the goal of keeping the implementation tiny while remaining practical for everyday use.

This module is heavily inspired by L<Mojo::Template>, but intentionally reduces features to keep the code size minimal and easy to understand.

Templates support two types of tags:

  <% Perl code %>
  <%= Perl expression %>

The C<E<lt>% %E<gt>> tag executes arbitrary Perl code.
The C<E<lt>%= %E<gt>> tag evaluates a Perl expression and appends its result.

If you need HTML escaping, use the C<escape_html> function explicitly:

  <%= escape_html($value) %>

No automatic escaping is performed.

=head1 ATTRIBUTES

The following attributes control the syntax of template tags.
Each attribute acts as a getter/setter.

=head2 tag_start

Start delimiter for template tags. Default: C<< <% >>.

  $tt->tag_start('[#');
  say $tt->tag_start;  # [#

=head2 tag_end

End delimiter for template tags. Default: C<< %> >>.

  $tt->tag_end('#]');
  say $tt->tag_end;    # #]

=head2 expression_mark

Marker used to indicate expression tags. Default: C<=>.

  $tt->expression_mark('==');
  say $tt->expression_mark;  # ==

=head1 METHODS

=head2 new

  my $tt = Text::TinyTemplate->new;

Constructs a new C<Text::TinyTemplate> object.

=head2 render($template, \%data)

  my $output = $tt->render($template, { greeting => 'Hello' });

Renders the given template and returns the resulting string.

The first argument must be a scalar containing the template text.
The second argument must be a hash reference.  
Each key in the hash becomes a variable available inside the template.

Internally, the template is converted into Perl code and evaluated.
Because of this, B<never use untrusted template input>.  
Templates can execute arbitrary Perl code.

=head1 SECURITY

Templates are executed via C<eval>.  
This means:

=over 4

=item *

Template authors can run arbitrary Perl code.

=item *

Never render templates from untrusted sources.

=item *

HTML escaping is not automatic; use C<escape_html> when needed.

=back

=head1 SEE ALSO

L<Mojo::Template>

=head1 AUTHOR

Yasuyoshi Sako

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
