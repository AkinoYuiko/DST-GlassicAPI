GLOBAL.setfenv(1, GLOBAL)

local function split_str(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        if not match:find("Glassic API") then
            table.insert(result, match);
        end
    end
    return result;
end

if TheNet then
    local network = getmetatable(TheNet).__index
    local get_server_mods_description = network.GetServerModsDescription
    network.GetServerModsDescription = function(...)
        local sep = ", "
        local str = get_server_mods_description(...)
        local t = split_str(str, sep)
        return table.concat(t, sep)
    end

    local get_server_mods_enabled = network.GetServerModsEnabled
    network.GetServerModsEnabled = function(...)
        local modsStr = TheNet:GetServerModsDescription()
        if modsStr == "" then
            return false
        end
        return unpack({get_server_mods_enabled(...)})
    end
end
