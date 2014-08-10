cyclic-requires
===============

This is an extremely simple script to scan your CoffeeScript node modules for
cyclic require calls.

This was thrown together because the only other promising tool, [madge], was
just not working.  Furthermore, cyclic requires can sometimes be perfectly
fine, so long as they are "late-bound" and run within some function rather than
during the initial top-level module loading phase that most applications are
structured with—hence this tool ignores nested require calls.

This tool doesn't even do any parsing of the sources, but instead just uses
regular expressions.  This has actually worked great for a number of projects
I've applied it to.

It should be easy to tweak this script to work for JavaScript as well.
