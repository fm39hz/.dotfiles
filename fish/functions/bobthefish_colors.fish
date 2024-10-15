function bobthefish_colors -S -d 'Define a custom bobthefish color scheme'
    # then override everything you want! note that these must be defined with `set -x`
    set -x color_initial_segment_exit ffffff E67E80 --bold # red
    set -x color_initial_segment_private ffffff 7FBBB3 # blue
    set -x color_initial_segment_su ffffff A7C080 --bold # green
    set -x color_initial_segment_jobs ffffff 7FBBB3 --bold # blue
    set -x color_path 2D353B D3C6AA --bold # bg0 and bg5
    set -x color_path_basename 2D353B D3C6AA --bold
    set -x color_path_nowrite 543A48 D699B6 # bg_red and purple
    set -x color_path_nowrite_basename 543A48 D699B6 --bold # bg_red and purple
    set -x color_repo A7C080 425047 # green and bg_green
    set -x color_repo_work_tree 2D353B ffffff --bold
    set -x color_repo_dirty E67E80 232A2E # red
    set -x color_repo_staged DBBC7F 4D4C43 # yellow and bg_yellow
    set -x color_vi_mode_default 7FBBB3 2D353B --bold # blue and bg0
    set -x color_vi_mode_insert A7C080 2D353B --bold # green and bg0
    set -x color_vi_mode_visual DBBC7F 4D4C43 --bold # yellow and bg_yellow
    set -x color_vagrant 7FBBB3 ffffff --bold # blue
    set -x color_aws_vault
    set -x color_aws_vault_expired
    set -x color_username 3D484D A7C080 --bold # fg and blue
    set -x color_hostname 3D484D A7C080 --bold # fg and blue
    set -x color_rvm E67E80 D3C6AA --bold # red and fg
    set -x color_virtualfish 83C092 D3C6AA --bold # aqua and fg
    set -x color_virtualgo 83C092 D3C6AA --bold # aqua and fg
    set -x color_desk 83C092 D3C6AA --bold # aqua and fg
    set -x color_nix 83C092 D3C6AA --bold # aqua and fg
end
