local hs = require("hyprsplit")
local M = {}

-- Tìm cửa sổ dựa trên regex
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

-- Logic focus ứng dụng thông minh (Bọc qua lớp cựu tốc C++ runapp)
function M.app_focus(term, class, workspace, is_class, extra_args)
	local win = get_win(term, is_class)
	if win then
		local target_ws = win.workspace.id
		if target_ws < 0 then
			target_ws = win.workspace.name or workspace
		end
		hl.dispatch(hs.dsp.focus({ workspace = target_ws }))
	else
		hl.dispatch(hs.dsp.focus({ workspace = workspace }))
		-- THAY THẾ: Chuyển tiền tố sang runapp để bắn lệnh trực tiếp vào socket systemd
		local cmd = string.format("runapp %s %s", class, extra_args or "")
		hl.dispatch(hl.dsp.exec_cmd(cmd))
	end
end

-- Logic kéo cửa sổ về workspace hiện tại
function M.bring_here(term, class, is_class, extra_args)
	local win = get_win(term, is_class)
	if win then
		hl.dispatch(hl.dsp.window.move({ workspace = "current", window = "address:" .. win.address }))
		hl.dispatch(hl.dsp.window.focus({ window = "address:" .. win.address }))
	else
		-- THAY THẾ: Khởi chạy launcher/app độc lập qua runapp
		hl.dispatch(hl.dsp.exec_cmd("runapp " .. class .. " " .. (extra_args or "")))
	end
end

return M
