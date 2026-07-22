-- "rose-pine" here is the colorscheme name; kept in sync by hand with the
-- `name = "rose-pine"` plugin spec in lua/monzork/lazy.lua.
local function color_my_pencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)
end

color_my_pencils()
