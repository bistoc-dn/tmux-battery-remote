get_tmux_option() {
	local option="$1"
	local default_value="$2"
	local option_value="$(tmux show-option -gqv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

battery_status() {
	# pmset -g batt | awk -F '; *' 'NR==2 { print $2 }'
	if [ -f /tmp/tmux_battery_remote_pmset_out ]; then
		cat /tmp/tmux_battery_remote_pmset_out | awk -F '; *' 'NR==2 { print $2 }'
	else
		echo no status
	fi
}
