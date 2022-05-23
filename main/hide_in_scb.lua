GLOBAL.setfenv(1, GLOBAL)

if TheNet then
    local network = getmetatable(TheNet).__index
    local get_server_mods_description = network.GetServerModsDescription
    network.GetServerModsDescription = function(...)
        local server_mod_names = {}
        local server_mods = GetEnabledModsModInfoDetails()
        for _, mod in ipairs(server_mods) do
            local info_name = mod.info_name
            if not info_name:find('Glassic API') then
                table.insert(server_mod_names, info_name)
            end
        end
        return table.concat(server_mod_names, ", ")
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
