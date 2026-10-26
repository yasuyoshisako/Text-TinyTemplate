# Text::TinyTemplate

A very small and simple template engine for Perl.  
Inspired by **Mojo::Template**, but intentionally reduced to the minimum feature set to keep the implementation tiny, dependency-free, and easy to understand.

This distribution also includes `Text::TinyTemplate::Utils`, which provides minimal HTML escaping and accessor generation helper functions.

---

## Features

- Tiny implementation (easy to read and modify)
- No dependencies (Perl 5.8+ only)
- **Automatic variable unpacking**: Hash keys matching `/^\w+$/` become local lexical variables inside templates automatically.
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

## Installation & Setup

Since `Text::TinyTemplate` is managed locally within your project, place the module files under your project structure:

1. Place the files into your `lib/` directory:
   - `lib/Text/TinyTemplate.pm`
   - `lib/Text/TinyTemplate/Utils.pm`

2. Use `use lib` in your scripts to include them:

   ```perl
   use lib 'lib';
   use Text::TinyTemplate;
   ```

## Synopsis

```
use lib 'lib';
use Text::TinyTemplate;

my $template = do { local$/; <DATA> };
my $data = {
    title  => 'Name list',
    people => [
        { name => 'Smith', age => 42 },
        { name => 'John',  age => 37 },
        { name => 'Lewis', age => 28 },
    ],
};

my $tt = Text::TinyTemplate->new;
my $output =$tt->render($template,$data);

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
      <li><%= $person->{name} \%> : <\%=$person->{age} %> years old</li>
    <% } %>
    </ul>
  </body>
</html>
```

## Limitations

Because `Text::TinyTemplate` prioritizes extreme simplicity, it has the following constraints regarding quoting: You can freely use single quotes (`'`) outside of template tags (i.e., in static HTML/text).
Do not use single quotes (`'`) inside template tags because they interfere with the internal string construction.
Instead, use double quotes (`"`), `q()`, or `qq()`.
Example of correct usage inside tags:

```
<%= $data->{"name"} %>
<% if ($user->{role} eq "admin") { %>
  ...
<% } %>
```

## Multibyte Strings (UTF-8)

When handling multibyte strings (such as Japanese) in templates or data structures, make sure to decode strings into Perl's internal character semantics beforehand, and encode the final output if necessary using the `Encode` module.

```
use Encode qw( decode encode );

my $template = decode('UTF-8',$raw_template);
my $data = {
    name => decode('UTF-8', '日本語の名前'),
};

my $output =$tt->render($template,$data);
print encode('UTF-8', $output) . "\n";
```

## HTML Escaping & Utilities

`Text::TinyTemplate::Utils` provides a minimal HTML escaping function:

```
use Text::TinyTemplate::Utils qw( escape_html );

my $safe = escape_html('<script>alert(1)</script>');
# &lt;script&gt;alert(1)&lt;/script&gt;
```

## Security Notice

Templates are converted into Perl code and evaluated with `eval`.
This means:

- **Never render untrusted templates**
- Template authors can execute arbitrary Perl code
- HTML escaping is not automatic; use `escape_html` when needed.

This module is intended for trusted environments or learning purposes.

## Requirements

- Perl 5.8 or later
- No non-core dependencies

## Why Tiny?

This module was created as a learning project to understand how template engines work internally.
It follows the tradition of many Perl “Tiny” modules:

- small codebase
- minimal features
- easy to read
- dependency-free

If you need a full-featured template engine, consider:

- `Mojo::Template`
- `Template Toolkit`
- `Text::Xslate`

## License

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

---

## Author

Yasuyoshi Sako
