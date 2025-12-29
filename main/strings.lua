local env = env
GLOBAL.setfenv(1, GLOBAL)

local strings = {
	UI = {
		RARITY = {
			Glassic = "Glassic",
		},
	},
	SKIN_TAG_CATEGORIES = {
		COLLECTION = {
			GLASSIC = "Glassic Collection",
		},
	},
}

GlassicAPI.MergeStringsToGLOBAL(strings)
GlassicAPI.MergeTranslationFromPO(env.MODROOT .. "languages")

-- if env.is_mim_enabled then return end
function UpdateGlassicStrings()
	local file, errormsg = io.open(env.MODROOT .. "languages/strings.pot", "w")
	if not file then
		print("Can't generate " .. env.MODROOT .. "languages/strings.pot" .. "\n" .. tostring(errormsg))
		return
	end
	GlassicAPI.MakePOTFromStrings(file, strings)
end
