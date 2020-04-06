
-- This function converts the relative link to reference file 
-- in the same documentation. Instead of `File <./file>`__ it 
-- becomes :doc:`./file`. And if the link starts with // (for folder)
-- when exported from markdown2rst e.g it converts `File <.//file>`__
-- to :doc:`./file/index`
function Link(el)
    if (string.find(el.target, "%.//")) then 
        return pandoc.RawInline("rst", ":doc:`" .. el.target .. "/index`")
    end  
    if (string.find(el.target, "%./")) then 
        return pandoc.RawInline("rst", ":doc:`" .. el.target .. "`")
    end
    return el
end

-- Replace \ with \\
function RawInline(raw)
    if (string.find(raw.text, "\\")) then 
        return pandoc.Str(raw.text:gsub("\\", "/"))
    end
    return raw
end

function Pandoc(doc)
    local filename = string.match(PANDOC_STATE.output_file, "/(.*)")
    for i in string.gmatch(filename, "[^.]+") do
      filename = i
      break
    end
    local hblocks = {}
    local el = pandoc.Para("\n\n"          ..
                           ".. index::\n"    ..
                           "	single: "  .. filename ..
                           "\n\n\n\n")
    table.insert(hblocks, el)
    for i,el in pairs(doc.blocks) do
        table.insert(hblocks, el)
    end
    return pandoc.Pandoc(hblocks, doc.meta)
end