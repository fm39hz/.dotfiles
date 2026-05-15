-- Định nghĩa các đường cong (Giữ nguyên)
hl.curve("smoothDrive", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("overdrive", { type = "bezier", points = { { 0.10, 0.9 }, { 0.1, 1.05 } } })
hl.curve("zoomIn", { type = "bezier", points = { { 0.85, 0 }, { 0.15, 1 } } })

-- SỬA LỖI: Đổi toàn bộ 'curve =' thành 'bezier ='
hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "smoothDrive" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "overdrive" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "smoothDrive", style = "slidefade" })
