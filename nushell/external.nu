# 1. Load logic gốc của zoxide (như code bạn vừa gửi)
source ~/.zoxide.nu

# =========================================================
# 2. THÊM ĐOẠN CUSTOM COMPLETION NÀY VÀO SAU
# =========================================================

# Hàm này trộn lẫn kết quả của zoxide và file local (ls)
def "nu-complete zoxide path" [context: string] {
    let parts = $context | split row " " | skip 1
    let query = $parts | str join " "

    # Lấy data từ zoxide
    let zoxide_results = (zoxide query --list --exclude $env.PWD -- ...$parts | lines)

    # Lấy data từ file system (giả lập hành vi của cd)
    let fs_results = if ($query | str starts-with ".") or ($query | str starts-with "/") or ($query | str starts-with "~") or ($query | is-empty) {
        do -i {
            ls -a ($query + "*") 
            | where type == dir 
            | get name 
            | each {|it| if ($it | str contains " ") { $'`($it)`' } else { $it }}
        }
    } else {
        []
    }

    # Gộp lại và xóa trùng
    let merged = ($fs_results | append $zoxide_results | uniq)

    {
        options: {
            sort: false,
            completion_algorithm: prefix,
            positional: false,
            case_sensitive: false,
        },
        completions: $merged,
    }
}

# 3. GHI ĐÈ LỆNH 'z'
# Mặc định zoxide init tạo alias z = __zoxide_z
# Ta định nghĩa lại 'z' là một hàm để gắn completion vào
def --env --wrapped z [...rest: string@"nu-complete zoxide path"] {
    __zoxide_z ...$rest
}

# 4. Alias cho zi (không cần sửa completion vì zi là interactive)
alias zi = __zoxide_zi
