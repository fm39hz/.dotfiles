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

-- Logic focus ứng dụng (Thay thế manage_focus)
function M.app_focus(term, class, workspace, is_class, extra_args)
	local win = get_win(term, is_class)
	if win then
		-- Nếu đã mở, focus vào workspace hiện tại của nó
		hl.dispatch(hl.dsp.workspace.focus({ workspace = win.workspace.id }))
	else
		-- Nếu chưa mở, nhảy sang workspace đích và chạy ứng dụng
		hl.dispatch(hl.dsp.workspace.focus({ workspace = workspace }))
		-- Bạn có thể thêm "uwsm app -- " vào trước %s nếu vẫn dùng uwsm
		local cmd = string.format("%s %s", class, extra_args or "")
		hl.dispatch(hl.dsp.exec_cmd(cmd))
	end
end

-- Logic kéo cửa sổ về hiện tại (Thay thế bring_window_to_current)
function M.bring_here(term, class, is_class, extra_args)
	local win = get_win(term, is_class)
	if win then
		hl.dispatch(hl.dsp.window.move({ workspace = "current", window = "address:" .. win.address }))
		hl.dispatch(hl.dsp.window.focus({ window = "address:" .. win.address }))
	else
		hl.dispatch(hl.dsp.exec_cmd(class .. " " .. (extra_args or "")))
	end
end

return M
