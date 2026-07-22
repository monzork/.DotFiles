-- Parse-checks every Lua file passed as an argument without executing it.
-- Run via `nvim --clean -l scripts/lua-syntax.lua <files...>`.
local failed = 0

for _, path in ipairs(arg) do
    local chunk, err = loadfile(path)
    if not chunk then
        io.stderr:write(err .. "\n")
        failed = failed + 1
    end
end

if failed > 0 then
    io.stderr:write(("\n%d file(s) failed to parse\n"):format(failed))
    os.exit(1)
end
