
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
