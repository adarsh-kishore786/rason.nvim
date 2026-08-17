# rason.nvim

A small Neovim plugin that reformats a visually-selected chunk of text — expanding
brackets and breaking on delimiters/separators onto new lines with indentation,
similar to running a one-liner through a pretty-printer. Select a cramped
function call / object literal / JSON-ish blob, hit a key, get it laid out
across multiple lines.

Most of the existing plugins out there come with a JSON parser and so can format
only valid JSON. This plugin contains just a lexer and no parser, meaning it is not
required for the selected text to conform to any specific grammar. This is a double
edged sword, and depends on the text being selected.

## What it actually does

1. You visually select some text (charwise `v` or linewise `V`).
2. `<leader>j` runs a hand-written lexer (`lexer.lua`) over the selection,
   splitting it into tokens: variables/strings, delimiters (`,` `;`),
   brackets (`()[]{}`), colons (`:`), and "separators" (`|` `&` `=`).
3. `rason.lua` walks those tokens and rebuilds a string, opening a new,
   indented line after most delimiters and inside brackets that contain
   more than one token — brackets with 0 or 1 tokens inside are kept
   inline.
4. The result replaces your original selection in the buffer.

There's no parser and no AST — it's a linear token stream with some
lookahead heuristics (`is_empty_bracket`, `contains_one_lexeme`,
`no_newline_character`) to decide where line breaks go.

## Installation

**lazy.nvim**
```lua
{
  "adarsh-kishore786/rason.nvim",
  config = function()
    require("rason").setup()
  end,
}
```

**packer.nvim**
```lua
use {
  "adarsh-kishore786/rason.nvim",
  config = function()
    require("rason").setup()
  end,
}
```

## Usage

1. Select some text in visual mode.
2. Press `<leader>j`.
3. The selection is replaced with the reformatted version.
## License

Not specified in the repository.
