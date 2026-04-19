# Text::TinyTemplate

A very small and simple template engine for Perl.  
Inspired by **Mojo::Template**, but intentionally reduced to the minimum feature set to keep the implementation tiny, dependency-free, and easy to understand.

This distribution also includes `Text::TinyTemplate::Utils`, which provides a minimal HTML escaping function.

---

## Features

- Tiny implementation (easy to read and modify)
- No dependencies (Perl 5.8+ only)
- Familiar tag syntax:
  - `<% Perl code %>`
  - `<%= Perl expression %>`
- Optional HTML escaping via `escape_html`
- Customizable tag delimiters

This module is suitable for:

- Learning how template engines work internally  
- Embedding small templates in scripts  
- Environments where dependencies must be minimized  

---

## Installation

```
cpanm Text::TinyTemplate
```

or manually:

```
perl Makefile.PL
make
make test
make install
```
---

## Synopsis

```
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
```

---

## HTML Escaping

Text::TinyTemplate::Utils provides a minimal HTML escaping function:

```
use Text::TinyTemplate::Utils qw( escape_html );

my $safe = escape_html('<script>alert(1)</script>');
# &lt;script&gt;alert(1)&lt;/script&gt;
```

You can also add custom escape rules:

```
escape_html('<', { '<' => 'foo' });  # &foo;
```
---

## Security Notice

Templates are converted into Perl code and evaluated with `eval`.
This means:

- **Never render untrusted templates**
- Template authors can execute arbitrary Perl code
- HTML escaping is **not automatic**

This module is intended for trusted environments or learning purposes.

---

## Requirements

- Perl 5.8 or later
- No non-core dependencies

---

## Why Tiny?

This module was created as a learning project to understand how template engines work internally.
It follows the tradition of many Perl “Tiny” modules:

- small codebase
- minimal features
- easy to read
- dependency-free

If you need a full-featured template engine, consider:

- Mojo::Template
- Template Toolkit
- Text::Xslate

---

## License

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

---

## Author

Yasuyoshi Sako