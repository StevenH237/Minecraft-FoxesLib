module = {}
local c = require('colorUtils')



module.upgrade = function(monitor)
  monitor.defaultBackground = monitor.getBackgroundColor()
  monitor.defaultText = monitor.getTextColor()

  monitor.setDefaultBackground = function(color)
    monitor.defaultBackground = color
    monitor.setBackgroundColor(monitor.defaultBackground)
  end

  monitor.setDefaultText = function(color)
    monitor.defaultText = color
    monitor.setTextColor(monitor.defaultText)
  end

  monitor.wipe = function()
    monitor.setBackgroundColor(monitor.defaultBackground)
    monitor.setTextColor(monitor.defaultText)
    monitor.setCursorPos(1, 1)
    monitor.clear()
  end

  monitor.resetPalette = function()
    for _, v in pairs(c.allColors) do
      monitor.setPaletteColor(v, term.nativePaletteColor(v))
    end
  end

  monitor.ezBlit = function(text, backgroundColor, textColor)
    bg = string.rep(colors.toBlit(backgroundColor), #tostring(text))
    fg = string.rep(colors.toBlit(textColor), #tostring(text))
    monitor.blit(tostring(text), bg, fg)
  end

  monitor.randomColors = function()
    local b = monitor.getBackgroundColor()
    local t = monitor.getTextColor()
    monitor.setPaletteColor(b, math.random(), math.random(), math.random())
    monitor.setPaletteColor(t, math.random(), math.random(), math.random())
  end
end

module.runOnAll = function(monitors, fxn, ...)
  local params = ...
  for _, v in pairs(monitors) do
    v[fxn](params)
  end
end

module.upgradeAll = function(monitors)
  for _, v in pairs(monitors) do
    module.upgrade(v)
  end
end

module.getAllMonitors = function()
  ms = { peripheral.find('monitor') }
  module.upgradeAll(ms)
  return ms
end

return module