-- Copy As Focus Link
function urlEncode(input)
	local output = input:gsub(">", "%%3E"):gsub("%s", "%%20")
	return output
end
function getFocusedCommand()
	for menu.get_current_ui_list():getChildren() as cmd do
		if cmd:isFocused() then return cmd end
	end
end
local tab_root = menu.ref_by_path("Self"):getParent()
local version_info = menu.get_version()
local root_name_ref = menu.ref_by_path("Stand>Settings>Appearance>Address Bar>Root Name")
local address_separator_ref = menu.ref_by_path("Stand>Settings>Appearance>Address Bar>Address Separator")
function getPathFromRef(ref: userdata, lang_code: ?string = nil, override_separator: ?string = nil, include_root_name: bool = true): string
    local path = ""
    local separator = override_separator ?? address_separator_ref:getState():gsub(version_info.brand, ""):gsub("Online", "")
    local cmd = ref
    while cmd:isValid() and (include_root_name or not cmd:equals(tab_root)) do
        local name = cmd:equals(tab_root) ? (root_name_ref.value != 0 ? (root_name_ref:getState():gsub("{}", version_info.version)) : "") : cmd.menu_name
        local hash = tonumber(name)
        if hash then
            name = lang.get_string(hash, lang_code ?? lang.get_current())
        end
        if #name > 0 then
            path = name .. separator .. path
        end
        cmd = cmd:getParent()
    end
    if path == "" then
        return ""
    end
    return path:sub(0, -(separator:len() + 1))
end
function getCommandFromRef(default)
    for menu.get_command_names(getFocusedCommand()) as input do
        local state = getFocusedCommand():getState()
        if default then input = input.." ".. getFocusedCommand():getDefaultState() else input = input.." ".. state end
        local output = input:gsub("%s", "%%20")
        return tostring(output)
    end
end
function getCommandDefault()
    local state = getFocusedCommand():getState()
    local default_state = getFocusedCommand():getDefaultState()
    if state != default_state then
        return default_state
    end
end