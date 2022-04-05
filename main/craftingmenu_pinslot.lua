GLOBAL.setfenv(1, GLOBAL)

local PinSlot = require("widgets/redux/craftingmenu_pinslot")

function PinSlot:Refresh()
	local data = self.craftingmenu:GetRecipeState(self.recipe_name)

	local is_left = self.craftingmenu.is_left_aligned
	local item_size = 80

	local atlas = resolvefilepath(CRAFTING_ATLAS)

	if data ~= nil and data.recipe ~= nil and data.meta ~= nil then
		local recipe = data.recipe
		local meta = data.meta

		if self.recipe_popup:IsVisible() then
			self.recipe_popup:ShowPopup(recipe)
		end

		local inv_image
		if self.skin_name ~= nil then
			inv_image = GetSkinInvIconName(self.skin_name)..".tex"
		else
			inv_image = recipe.imagefn ~= nil and recipe.imagefn() or recipe.image
		end
		-- local inv_atlas = recipe:GetAtlas()
        local inv_atlas = GetInventoryItemAtlas(inv_image) or recipe:GetAtlas()

		self.item_img:SetTexture(inv_atlas, inv_image or "default.tex", "default.tex")
		self.item_img:ScaleToSize(is_left and item_size or -item_size, item_size)
		self.item_img:SetTint(1, 1, 1, 1)

		if meta.build_state == "buffered" then
			self.craft_button:SetTextures(atlas, "pinslot_bg_buffered.tex", nil, nil, nil, "pinslot_bg_buffered.tex")
			self.fg:Hide()
		elseif meta.build_state == "prototype" and meta.can_build then
			self.craft_button:SetTextures(atlas, "pinslot_bg_prototype.tex", nil, nil, nil, "pinslot_bg_prototype.tex")
			self.fg:SetTexture(atlas, "pinslot_fg_prototype.tex")
			self.fg:Show()
		elseif meta.can_build then
			self.craft_button:SetTextures(atlas, "pinslot_bg.tex", nil, nil, nil, "pinslot_bg.tex")
			self.fg:Hide()
		elseif meta.build_state == "hint" then
			self.craft_button:SetTextures(atlas, "pinslot_bg_missing_mats.tex", nil, nil, nil, "pinslot_bg_missing_mats.tex")
			self.item_img:SetTint(0.7, 0.7, 0.7, 1)
			self.fg:SetTexture(atlas, "pinslot_fg_lock.tex")
            self.fg:Show()
		elseif meta.build_state == "no_ingredients" or meta.build_state == "prototype" then
			self.craft_button:SetTextures(atlas, "pinslot_bg_missing_mats.tex", nil, nil, nil, "pinslot_bg_missing_mats.tex")
			self.item_img:SetTint(0.7, 0.7, 0.7, 1)
            self.fg:Hide()
		else
			self.craft_button:SetTextures(atlas, "pinslot_bg_missing_mats.tex", nil, nil, nil, "pinslot_bg_missing_mats.tex")
			self.item_img:SetTint(0.7, 0.7, 0.7, 1)
			self.fg:SetTexture(atlas, "pinslot_fg_lock.tex")
            self.fg:Show()
		end

		local details_recipe_name, details_skin_name = self.craftingmenu:GetCurrentRecipeName()
		self.craft_button:SetHelpTextMessage(details_recipe_name ~= self.recipe_name and STRINGS.UI.HUD.SELECT
											 or meta.build_state == "buffered" and STRINGS.UI.HUD.DEPLOY
											 or STRINGS.UI.HUD.BUILD)

		self:Show()
	else
		self.craft_button:SetTextures(atlas, "pinslot_bg_missing_mats.tex", nil, nil, nil, "pinslot_bg_missing_mats.tex")
        self.fg:Hide()
		self.item_img:SetTexture(atlas, "pinslot_fg_pin.tex")
		self.item_img:ScaleToSize(is_left and item_size or -item_size, item_size)

		self.craft_button:SetHelpTextMessage(STRINGS.UI.CRAFTING_MENU.PIN)
	end

end
