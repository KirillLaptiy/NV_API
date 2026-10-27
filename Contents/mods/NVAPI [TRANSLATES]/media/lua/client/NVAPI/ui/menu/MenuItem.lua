local ItemMenuApply   = require "NVAPI/ui/menu/MenuItemApply"
local ItemNightVision = require "NVAPI/item/ItemNightVision"
local nvctrl          = require "NVAPI/ctrl/instance"
local Option          = require "NVAPI/lib/ui/Option"


-- Create [NV] Brightness Menu
--------------------------------------------------------------------------------
local function addFilterOptionToMenu( context, player, nvitem )

  local label        = (getText("ContextMenu_[NV]_Filter"))
  local filterOption = context:addOption( label, nvitem:getBoundItem(), nil )
  local submenu      = ISContextMenu:getNew( context )
  context:addSubMenu( filterOption, submenu )


  for _, filter in ipairs( nvitem.param:getAvailableFilters() ) do
    local label    = filter[1]
    local tex      = filter[2]
    local callback = function() ItemMenuApply.filter( nvitem, label ) end

    submenu:addOption( label, player, callback )
  end

end



-- Create [NV] Brightness Menu
--------------------------------------------------------------------------------
local function addBrightnessOptionToMenu( context, player, nvitem )

  local label   = (getText("ContextMenu_[NV]_Brightness"))
  local option  = context:addOption( label, nvitem:getBoundItem(), nil )
  local submenu = ISContextMenu:getNew( context )
  context:addSubMenu( option, submenu )


  for label, intensity in pairs( nvitem.param:getAvailableBrightness() ) do

    local translatedLabel = ""

  if label == "Min" then
    translatedLabel = getText("ContextMenu_Min")
  elseif label == "Med" then
    translatedLabel = getText("ContextMenu_Med")
  elseif label == "Max" then
    translatedLabel = getText("ContextMenu_Max")
  end

    local callback = function() ItemMenuApply.brightness( nvitem, intensity ) end
    submenu:addOption( translatedLabel, player, callback )



  end

end


-- Create [NV] Charge Menu
--------------------------------------------------------------------------------
local function addRechargeOptionToMenu( context, player, nvitem )

  local label  = (getText("ContextMenu_[NV]_Charge |")) .. nvitem.charge:getPercent()
  local action = function() ItemMenuApply.recharge( player, nvitem ) end

  local chargeAmount = function()
    return nvitem.charge:isFull()
  end

  local batteryAvailable = function()
    return player:getInventory():getFirstTypeRecurse("Battery") == nil
  end


  local opt = Option:new( label, action )
  opt:check( chargeAmount    , getText("ContextMenu_item_is_fully_charged") )
  opt:check( batteryAvailable, getText("ContextMenu_Need_a_battery_to_recharge") )
  opt:renderTo( context, nvitem:getBoundItem() )

end


-- Create [NV] Repair Menu
--------------------------------------------------------------------------------
local function addRepairOptionToMenu( context, player, nvitem )

  local label  = (getText("ContextMenu_[NV]_Repair"))
  local action = function() ItemMenuApply.repair( player, nvitem ) end


  local notBroken = function()
    return not nvitem:isBroken()
  end

  local cannotBeRepaired = function()
    return not nvitem:canBeRepaired()
  end

  local opt = Option:new( label, action )
  opt:check( notBroken       , getText("ContextMenu_item_is_not_broken") )
  opt:check( cannotBeRepaired, nvitem.recipe.repair:displayRecipes() )
  opt:renderTo( context, nvitem:getBoundItem() )

end



-- Fill menu options if the selected item is nv capable
---------------------------------------------------------------------------
local function OnFillInventoryObjectContextMenu( _player, context, _items )

  local player   = getSpecificPlayer( _player )
  local itemList = ISInventoryPane.getActualItems( _items )

  -- multiple selection not allowed
  ---------------------------------
  local isMultipleSelection = itemList[2] ~= nil
  if isMultipleSelection then
    return
  end

  -- wrap the selected item to access nv functions
  ------------------------------------------------
  local selectedItem = itemList[1]
  local nvitem       = ItemNightVision.wrap( selectedItem )

  -- do nothing if the item is not a nv item
  ------------------------------------------
  if nvitem:isnotNightVision() then
    return
  end

  -- if the selected item is attached to the controller,
  -- then create specific menu options
  ------------------------------------------------------
  addFilterOptionToMenu    ( context, player, nvitem )
  addBrightnessOptionToMenu( context, player, nvitem )
  addRechargeOptionToMenu  ( context, player, nvitem )
  if nvitem:isBroken() then
    addRepairOptionToMenu    ( context, player, nvitem )
  end

end

Events.OnFillInventoryObjectContextMenu.Add(OnFillInventoryObjectContextMenu)
