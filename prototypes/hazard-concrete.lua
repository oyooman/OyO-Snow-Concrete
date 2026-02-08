--------------------------------------------------------------------------------
-- Declare stripe types
--------------------------------------------------------------------------------
local ctypes = {
  -- HAZARD TYPES: Full custom sprites (frozen & standard, icons & tiles)
  { name = "emergency-concrete", is_tinted = false },
  { name = "express-concrete", is_tinted = false },
  { name = "green-concrete", is_tinted = false },
  { name = "operations-concrete", is_tinted = false },
  { name = "radiation-concrete", is_tinted = false },
  { name = "safety-concrete", is_tinted = false },
  { name = "warning-concrete", is_tinted = false },
  
  -- TINTED TYPES: 
  -- Custom PNGs for all 4 tile variants (Standard, Refined, Frozen Standard, Frozen Refined).
  -- Icons are vanilla 'concrete' icons with engine tinting.
  -- Uses hazard-concrete as base prototype to avoid transition bugs.
  { name = "custom-acid-concrete", is_tinted = true, tint = {r = 0.708, g = 0.996, b = 0.134} }, -- #B5FE22
  { name = "custom-black-concrete", is_tinted = true, tint = {r = 0.5, g = 0.5, b = 0.5} }, -- #808080
  { name = "custom-blue-concrete", is_tinted = true, tint = {r = 0.343, g = 0.683, b = 1} }, -- #57AEFF
  { name = "custom-brown-concrete", is_tinted = true, tint = {r = 0.757, g = 0.522, b = 0.371} }, -- #C1855F
  { name = "custom-cyan-concrete", is_tinted = true, tint = {r = 0.335, g = 0.918, b = 0.866} }, -- #55EABB
  { name = "custom-green-concrete", is_tinted = true, tint = {r = 0.173, g = 0.824, b = 0.25} }, -- #2CD240
  { name = "custom-orange-concrete", is_tinted = true, tint = {r = 1, g = 0.63, b = 0.259} }, -- #FFA142
  { name = "custom-pink-concrete", is_tinted = true, tint = {r = 1, g = 0.72, b = 0.833} }, -- #FFB8D4
  { name = "custom-purple-concrete", is_tinted = true, tint = {r = 0.821, g = 0.44, b = 0.998} }, -- #D170FF
  { name = "custom-red-concrete", is_tinted = true, tint = {r = 1, g = 0.266, b = 0.241} }, -- #FF443D
  { name = "custom-teal-concrete", is_tinted = true, tint = {r = 0.000, g = 0.502, b = 0.502} }, -- #008080
  { name = "custom-yellow-concrete", is_tinted = true, tint = {r = 1, g = 0.828, b = 0.231} }, -- #FFD33B
  


}

--------------------------------------------------------------------------------
-- Game Injection
--------------------------------------------------------------------------------
local dir = {
  { this = "left",  next = "right" },
  { this = "right", next = "left" }
}

for i = 1, #ctypes, 1 do
  local c_data = ctypes[i]

  -- Set active directions: Tinted only needs 1 tile, Hazard needs 2 for rotation
  local active_dirs = c_data.is_tinted and {{ this = "", next = "" }} or dir

--------------------------------------------------------------------------------
----- Tiles -----
--------------------------------------------------------------------------------
  for d = 1, #active_dirs, 1 do
    local d_info = active_dirs[d]
    
    -- Suffix management: "" for Tinted, "-left/-right" for Hazard
    local sfx = (d_info.this ~= "") and ("-" .. d_info.this) or ""
    -- Image suffix: All tinted variants point to the "-left" custom files
    local img_sfx = c_data.is_tinted and "-left" or sfx
    
    --------------------------------------------------------------------------------    
    -- Standard Frozen
    --------------------------------------------------------------------------------
    -- We always use hazard-concrete-X as base for better transitions
    local f_sta_base = "frozen-hazard-concrete-" .. (c_data.is_tinted and "left" or d_info.this)
    local f_sta = table.deepcopy(data.raw["tile"][f_sta_base])
    
    f_sta.name = "frozen-" .. c_data.name .. sfx
    f_sta.localised_name = {"item-name.frozen-" .. c_data.name}
    f_sta.next_direction = (d_info.next ~= "") and ("frozen-" .. c_data.name .. "-" .. d_info.next) or nil
    f_sta.minable.result = c_data.name
    f_sta.variants.material_background.picture = "__OyO-Snow-Concrete__/graphics/" .. c_data.name .. "/frozen-" .. c_data.name .. img_sfx .. ".png"
    f_sta.placeable_by.item = c_data.name
    if c_data.is_tinted then
      f_sta.map_color = c_data.tint
    end 
    f_sta.thawed_variant = c_data.name .. sfx
    
    --------------------------------------------------------------------------------
    -- Standard Tile
    --------------------------------------------------------------------------------
    local sta_base = "hazard-concrete-" .. (c_data.is_tinted and "left" or d_info.this)
    local sta = table.deepcopy(data.raw["tile"][sta_base])
    
    sta.name = c_data.name .. sfx
    sta.localised_name = {"item-name." .. c_data.name}
    sta.next_direction = (d_info.next ~= "") and (c_data.name .. "-" .. d_info.next) or nil
    sta.minable.result = c_data.name
    sta.variants.material_background.picture = "__OyO-Snow-Concrete__/graphics/" .. c_data.name .. "/" .. c_data.name .. img_sfx .. ".png"
    sta.placeable_by.item = c_data.name
    if c_data.is_tinted then
      sta.map_color = c_data.tint
    end 
    sta.frozen_variant = "frozen-" .. c_data.name .. sfx
    
    --------------------------------------------------------------------------------
    -- Refined Frozen
    --------------------------------------------------------------------------------
    local f_ref_base = "frozen-refined-hazard-concrete-" .. (c_data.is_tinted and "left" or d_info.this)
    local f_ref = table.deepcopy(data.raw["tile"][f_ref_base])
    
    f_ref.name = "frozen-refined-" .. c_data.name .. sfx
    f_ref.localised_name = {"item-name.frozen-refined-" .. c_data.name}
    f_ref.next_direction = (d_info.next ~= "") and ("frozen-refined-" .. c_data.name .. "-" .. d_info.next) or nil
    f_ref.minable.result = "refined-" .. c_data.name
    f_ref.variants.material_background.picture = "__OyO-Snow-Concrete__/graphics/" .. c_data.name .. "/frozen-refined-" .. c_data.name .. img_sfx .. ".png"
    f_ref.placeable_by.item = "refined-" .. c_data.name
    if c_data.is_tinted then
      f_ref.map_color = c_data.tint
    end 
    f_ref.thawed_variant = "refined-" .. c_data.name .. sfx

    --------------------------------------------------------------------------------
    -- Refined Tile
    --------------------------------------------------------------------------------
    local ref_base = "refined-hazard-concrete-" .. (c_data.is_tinted and "left" or d_info.this)
    local ref = table.deepcopy(data.raw["tile"][ref_base])
    
    ref.name = "refined-" .. c_data.name .. sfx
    ref.localised_name = {"item-name.refined-" .. c_data.name}
    ref.next_direction = (d_info.next ~= "") and ("refined-" .. c_data.name .. "-" .. d_info.next) or nil
    ref.minable.result = "refined-" .. c_data.name
    ref.variants.material_background.picture = "__OyO-Snow-Concrete__/graphics/" .. c_data.name .. "/refined-" .. c_data.name .. img_sfx .. ".png"
    ref.placeable_by.item = "refined-" .. c_data.name
    if c_data.is_tinted then
      ref.map_color = c_data.tint
    end 
    ref.frozen_variant = "frozen-refined-" .. c_data.name .. sfx
    
    data:extend({ f_sta, sta, f_ref, ref })
  end

  --------------------------------------------------------------------------------
  ----- Items -----
  --------------------------------------------------------------------------------

  -- Standard Item: Always cloned from 'concrete' for tinted versions to get the flat icon base
  local staItem_base = c_data.is_tinted and "concrete" or "hazard-concrete"
  local staItem = table.deepcopy(data.raw["item"][staItem_base])
  staItem.name = c_data.name
  staItem.localised_name = {"item-name." .. c_data.name}
  
  if c_data.is_tinted then
    -- Tinted items use vanilla concrete icon + engine tint
    staItem.icons = {{ icon = data.raw["item"]["concrete"].icon, tint = c_data.tint }}
    staItem.icon = nil
    staItem.place_as_tile.result = c_data.name
  else
    staItem.icon = "__OyO-Snow-Concrete__/graphics/icons/" .. c_data.name .. ".png"
    staItem.place_as_tile.result = c_data.name .. "-left"
  end

  -- Refined Item: Always cloned from 'refined-concrete' for tinted versions
  local refItem_base = c_data.is_tinted and "refined-concrete" or "refined-hazard-concrete"
  local refItem = table.deepcopy(data.raw["item"][refItem_base])
  refItem.name = "refined-" .. c_data.name
  refItem.localised_name = {"item-name.refined-" .. c_data.name}

  if c_data.is_tinted then
    refItem.icons = {{ icon = data.raw["item"]["refined-concrete"].icon, tint = c_data.tint }}
    refItem.icon = nil
    refItem.place_as_tile.result = "refined-" .. c_data.name
  else
    refItem.icon = "__OyO-Snow-Concrete__/graphics/icons/refined-" .. c_data.name .. ".png"
    refItem.place_as_tile.result = "refined-" .. c_data.name .. "-left"
  end

  --------------------------------------------------------------------------------
  ----- Recipes -----
  --------------------------------------------------------------------------------
  local staRec = table.deepcopy(data.raw["recipe"]["hazard-concrete"])
  staRec.name = c_data.name
  staRec.results[1].name = c_data.name

  local refRec = table.deepcopy(data.raw["recipe"]["refined-hazard-concrete"])
  refRec.name = "refined-" .. c_data.name
  refRec.results[1].name = "refined-" .. c_data.name

  data:extend({ staRec, refRec, staItem, refItem })
  table.insert(data.raw.technology["concrete"].effects, { type = "unlock-recipe", recipe = c_data.name })
  table.insert(data.raw.technology["concrete"].effects, { type = "unlock-recipe", recipe = 'refined-' .. c_data.name })
end