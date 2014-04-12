## Description

This defines three ruby text objects – block, class and function.
A block is delimited by the regex in the variable `g:ruby_block_openers` and
`end`.
A function is a special case of block, starting with `def`, class works the
same way.
The inner variant doesn't include the delimiter lines.

## Usage

By default, the omaps `ir` and `ar` are used for a block; `if` and `af` for a
function, `ic` and `ac` for a class.

Specifying a count selects outer blocks recursively.

## Customization

The variable `g:textobj_ruby_inclusive` controls whether leading comments and a
single blank line are included in the `a` object if present, defaulting to 1.

Consult the documentation of [textobj-user][1] for custom mappings.

## Details

The plugin uses a consistent line based approach, with the lines containing the
delimiters being part of the block.
This means that when invoking the text object on the word before a `do` will
select the block opened by it, which is especially useful on empty blocks.
When the `ir` object is used on the opener line, the selection will begin on
the next line.

The reason for inclusive mode is that when deleting or copying a function, you
most likely want to paste it somewhere else and not leave an additional empty
line around (given that you separate all functions by a single blank line).
Comments directly above a block are most likely connected to it, so leaving
them would be impractical.

When invoked multiple times in visual mode, the selection grows to the next
larger block, just like when invoking the operator with a count.
To decide whether to grow, the visual selection is checked – if start and end
do not match, it is assumed that the selection is already a block.
This can result in faulty behaviour when invoked from visual mode with o
nonzero selection and the cursor on the end delimiter line – the next outer
block will be selected.

## Dependencies

[textobj-user][1]

## License

Copyright (c) Torsten Schmits. Distributed under the terms of the [MIT
License][2].

[1]: https://github.com/kana/vim-textobj-user 'textobj-user'
[2]: http://opensource.org/licenses/MIT 'mit license'
