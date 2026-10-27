local CONFIG =
{
  ITEM_TAG          = "NVITEM",

  CHARGE_DRAIN_RATE = 0.0005,
  CHARGE_MAX        = 1,

  PARAM_VISCONE_INTENSITY  = 3,
  PARAM_VISCONE_RANGE      = 50,
  PARAM_OVERLAY_BRIGHTNESS = 0.2,
  PARAM_FILTER = {
    { getText("ContextMenu_Noiseless")   , getTexture("media/textures/overlay-noiseless.png")  },
    { getText("ContextMenu_Linear_Blur") , getTexture("media/textures/overlay-linearblur.png") },
    { getText("ContextMenu_Infrared")    , getTexture("media/textures/overlay-infrared.png")   },
    { getText("ContextMenu_X-ray")       , getTexture("media/textures/overlay-xray.png")       },
  },

  REPAIR_RECIPES = {
    {
      PERKS     = { Electricity = 4      },
      MATERIALS = { ElectronicsScrap = 2 },
      CHANCE    = function( level ) return 10 - level end,
      RESTORE   = function( level ) return 100        end
    }
  }

}

return CONFIG
