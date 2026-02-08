--------------------------------------------------------------------------------
-- Declare stripe types
--------------------------------------------------------------------------------
local ctypes = {
  { name = "oyo-red-concrete", tint = {r = 1, g = 0.266, b = 0.241} },
}

--------------------------------------------------------------------------------
-- Game Injection
--------------------------------------------------------------------------------
for i = 1, #ctypes, 1 do
  local c_data = ctypes[i]

--------------------------------------------------------------------------------
----- Tiles -----
--------------------------------------------------------------------------------

    --------------------------------------------------------------------------------
    -- Standard Frozen
    --------------------------------------------------------------------------------
    local f_sta = table.deepcopy(data.raw["tile"]["frozen-concrete"])
    f_sta.name = "frozen-" .. c_data.name
    f_sta.order = "z[frozen-concrete]-[frozen-" .. c_data.name .. "]"
    f_sta.minable.result = c_data.name
    f_sta.variants.material_background.picture = "__OyO_hasard-stripes__/graphics/" ..
      c_data.name .. "/frozen-" .. c_data.name .. ".png"
    f_sta.variants.material_background.tint = {r=1, g=1, b=1, a=1}
    
    f_sta.placeable_by = { item = c_data.name, count = 1 }
    f_sta.thawed_variant = c_data.name

    --------------------------------------------------------------------------------
    -- Standard
    --------------------------------------------------------------------------------
    local sta = table.deepcopy(data.raw["tile"]["concrete"])
    sta.name = c_data.name
    sta.order = "a[artificial]-b[tier-2]-c[" .. c_data.name .. "]"
    sta.minable.result = c_data.name
    sta.variants.material_background.picture = "__OyO_hasard-stripes__/graphics/" ..
      c_data.name .. "/" .. c_data.name .. ".png"
    sta.map_color = c_data.tint
    --sta.tint = c_data.tint
    
    --sta.layer = sta.layer + 5
    
    sta.placeable_by = { item = c_data.name, count = 1 }
    sta.frozen_variant = "frozen-" .. c_data.name

    --------------------------------------------------------------------------------
    -- refined Frozen
    --------------------------------------------------------------------------------
    local f_ref = table.deepcopy(data.raw["tile"]["frozen-refined-concrete"])
    f_ref.name = "frozen-refined-" .. c_data.name
    f_ref.order = "z[frozen-concrete]-[frozen-refined-" .. c_data.name .. "]"
    f_ref.minable.result = "refined-" .. c_data.name
    f_ref.variants.material_background.picture = "__OyO_hasard-stripes__/graphics/" ..
      c_data.name .. "/frozen-refined-" .. c_data.name .. ".png"
    f_ref.variants.material_background.tint = {r=1, g=1, b=1, a=1}
    f_ref.placeable_by = { item = "refined-" .. c_data.name, count = 1 }
    f_ref.thawed_variant = "refined-" .. c_data.name

    --------------------------------------------------------------------------------
    -- Refined
    --------------------------------------------------------------------------------
    local ref = table.deepcopy(data.raw["tile"]["refined-concrete"])
    ref.name = "refined-" .. c_data.name
    ref.order = "a[artificial]-c[tier-3]-a[refined-" .. c_data.name .. "]"
    ref.minable.result = "refined-" .. c_data.name
    
    ref.map_color = c_data.tint
    
    ref.placeable_by = { item = "refined-" .. c_data.name, count = 1 }
    ref.frozen_variant = "frozen-refined-" .. c_data.name

    data:extend({ f_sta, sta, f_ref, ref })

  --------------------------------------------------------------------------------
  ----- Recipes -----
  --------------------------------------------------------------------------------

  local staRec = table.deepcopy(data.raw["recipe"]["concrete"])
  staRec.name = c_data.name
  staRec.results[1].name = c_data.name

  local refRec = table.deepcopy(data.raw["recipe"]["refined-concrete"])
  refRec.name = "refined-" .. c_data.name
  refRec.results[1].name = "refined-" .. c_data.name

  --------------------------------------------------------------------------------
  ----- Items -----
  --------------------------------------------------------------------------------
  local base_item = data.raw["item"]["concrete"]
  local ref_base_item = data.raw["item"]["refined-concrete"]

  local staItem = table.deepcopy(base_item)
  staItem.name = c_data.name
  staItem.icons = {{
     icon = base_item.icon or (base_item.icons and base_item.icons[1].icon),
     icon_size = base_item.icon_size or 64,
     tint = c_data.tint
  }}
  staItem.order = "b[concrete]-b[" .. c_data.name .. "]"
  staItem.place_as_tile.result = c_data.name

  local refItem = table.deepcopy(ref_base_item)
  refItem.name = "refined-" .. c_data.name
  refItem.icons = {{
     icon = ref_base_item.icon or (ref_base_item.icons and ref_base_item.icons[1].icon),
     icon_size = ref_base_item.icon_size or 64,
     tint = c_data.tint
  }}
  refItem.order = "b[concrete]-d[refined-" .. c_data.name .. "]"
  refItem.place_as_tile.result = "refined-" .. c_data.name

  data:extend({ staRec, refRec, staItem, refItem })

  table.insert(data.raw.technology["concrete"].effects, { type = "unlock-recipe", recipe = c_data.name })
  table.insert(data.raw.technology["concrete"].effects, { type = "unlock-recipe", recipe = 'refined-' .. c_data.name })
end