# functions
# =========================================================================
bind-key    'M-n'     new-window \; split-window -v \; split-window -h \;\
                      select-pane -U \; split-window -h \; select-pane -L \;\
                      resize-pane -D 12 \; select-pane -D \; swap-pane -U \;\
                      select-pane -D \; swap-pane -U \; resize-pane -R 25 \;\
                      select-pane -U \; select-pane -L

bind-key     'N'      new-window \; split-window -h\; select-pane -L

bind-key -n 'M-Y'     copy-mode\;\
                      send-keys k0v$\;hy\;\
                      display "Yanked line above"

bind-key -n 'M-U'     copy-mode\;\
                      send-keys 0f\;\
                      send-keys 'Space'\;\
                      send-key lv$\hy\;\
                      send-keys 'C-u'

bind-key -t vi-copy Y copy-end-of-line
                      # run-shell "tmux show-buffer | pbcopy"
