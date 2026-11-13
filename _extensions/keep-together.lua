-- keep-together.lua
-- A div with class "keep-together" never splits across pages in Typst (PDF)
-- output: if it doesn't fit on the current page, it moves whole to the next
-- one, and Typst keeps the heading just above it attached. Use it for short
-- reference tables people print or photograph, e.g.
--
--   ::: {.keep-together}
--   | Symbol | Meaning | Example |
--   ...
--   :::
--
-- Only wrap things shorter than a page. In every other format the div is
-- dropped and its content kept as is.

function Div(el)
  if not el.classes:includes('keep-together') then
    return nil
  end
  if FORMAT:match('typst') then
    local blocks = { pandoc.RawBlock('typst', '#block(breakable: false)[') }
    for _, b in ipairs(el.content) do
      table.insert(blocks, b)
    end
    table.insert(blocks, pandoc.RawBlock('typst', ']'))
    return blocks
  end
  return el.content
end
