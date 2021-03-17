local base = _G

function getTerrainPathByName(strName)
	return base.getTerrainConfigPath(strName)
end

local function value2string(val)
    local t = type(val)
    if t == "number" or t == "boolean" then
        return tostring(val)
    elseif t == "table" then
        local str = ''
        local k,v
        for k,v in pairs(val) do
            str = str ..'['..value2string(k)..']='..value2string(v)..','
        end
        return '{'..str..'}'
    else
        return string.format("%q", tostring(val))
    end
end

function value2code(val)
    return 'return ' .. value2string(val)
end