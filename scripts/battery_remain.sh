#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/helpers.sh"

short=false

get_remain_settings() {
	short=$(get_tmux_option "@batt_remain_short" false)
}

battery_discharging() {
	local status="$(battery_status)"
	[[ $status =~ (discharging) ]]
}

battery_charged() {
	local status="$(battery_status)"
	[[ $status =~ (charged) || $status =~ (full) ]]
}

pmset_battery_remaining_time() {
	# pmset -g batt
	local status="$(cat /tmp/tmux_battery_remote_pmset_out)"
	if echo $status | grep 'no estimate' >/dev/null 2>&1; then
		if $short; then
			echo '~?:??'
		else
			echo '- Calculating estimate...'
		fi
	else
		local remaining_time="$(echo $status | grep -o '[0-9]\{1,2\}:[0-9]\{1,2\}')"
		if battery_discharging; then
			if $short; then
				echo $remaining_time | awk '{printf "~%s", $1}'
			else
				echo $remaining_time | awk '{printf "- %s left", $1}'
			fi
		elif battery_charged; then
			if $short; then
				echo $remaining_time | awk '{printf "charged", $1}'
			else
				echo $remaining_time | awk '{printf "fully charged", $1}'
			fi
		else
			if $short; then
				echo $remaining_time | awk '{printf "~%s", $1}'
			else
				echo $remaining_time | awk '{printf "- %s till full", $1}'
			fi
		fi
	fi
}

print_battery_remain() {
	pmset_battery_remaining_time
}

main() {
	get_remain_settings
	print_battery_remain
}
main
