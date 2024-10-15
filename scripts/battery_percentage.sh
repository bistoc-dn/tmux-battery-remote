#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"


print_battery_percentage() {
	# percentage displayed in the 2nd field of the 2nd row
	# pmset -g batt | grep -o "[0-9]\{1,3\}%"
	if [ -f /tmp/tmux_battery_remote_pmset_out ]; then
		cat /tmp/tmux_battery_remote_pmset_out | grep -o "[0-9]\{1,3\}%"
	else
		echo ?%
	fi
}

main() {
	print_battery_percentage
}
main
