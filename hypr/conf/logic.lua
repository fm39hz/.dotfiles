local hs = require("hyprsplit")
local M = {}

-- Regex matching
local function get_win(term, is_class)
	local wins = hl.get_windows()
	for _, w in ipairs(wins) do
		local target = is_class and w.class or w.title
		if target:lower():find(term:lower()) then
			return w
		end
	end
	return nil
end

-- Logic focus application
function M.app_focus(term, class, workspace, is_class, extra_args, use_runapp)
	if use_runapp == nil then use_runapp = true end
	local win = get_win(term, is_class)
	if win then
		local target_ws = win.workspace.id
		if target_ws < 0 then
			target_ws = win.workspace.name or workspace
		end
		hl.dispatch(hs.dsp.focus({ workspace = target_ws }))
	else
		hl.dispatch(hs.dsp.focus({ workspace = workspace }))
		local template = use_runapp and "runapp %s %s" or "%s %s"
		local cmd = string.format(template, class, extra_args or "")
		hl.dispatch(hl.dsp.exec_cmd(cmd))
	end
end

function M.bring_here(term, class, is_class, extra_args, use_runapp)
	if use_runapp == nil then use_runapp = true end
	local win = get_win(term, is_class)
	if win then
		hl.dispatch(hl.dsp.window.move({ workspace = "current", window = "address:" .. win.address }))
		hl.dispatch(hl.dsp.window.focus({ window = "address:" .. win.address }))
	else
		local template = use_runapp and "runapp %s %s" or "%s %s"
		local cmd = string.format(template, class, extra_args or "")
		hl.dispatch(hl.dsp.exec_cmd(cmd))
	end
end

return M
