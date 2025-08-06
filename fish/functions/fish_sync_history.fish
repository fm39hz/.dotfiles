function sync_pre_normal
    if not set --query fish_private_mode
        history save
        history merge
    end
end

respond_last_commandline --on-event fish_preexec

bind --mode insert \e 'sync_pre_normal; commandline -f cancel'
bind --mode insert j,k 'sync_pre_normal; commandline -f cancel'
