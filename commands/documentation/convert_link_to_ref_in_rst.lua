

function Link(el)
    if (string.match(el.target, "./")) then 
        return pandoc.RawInline("rst", ":doc:`" .. el.target .. "`")
    end
    return el
end
