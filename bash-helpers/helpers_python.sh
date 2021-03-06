#!/bin/bash

setup_virtual_env() { #helpmsg: Setup a virtual environment in current folder (in subfolder venv)
	# Where to find the binaries
	if [ "$OSTYPE" != "msys" ]; then
		VENV=$SCRIPT_DIR/venv/bin
	else
		VENV=$SCRIPT_DIR/venv/Scripts
	fi
	if [ "$OSTYPE" != "msys" ]; then
		install_debian_packages libffi-dev libssl-dev
	fi
	# Setup VENV
	if [ ! -e "$SCRIPT_DIR/venv" ]; then
		if [ "$OSTYPE" == "msys" ]; then
			if [ -e /c/Python37/python.exe ]; then
				PYTHON3=/c/Python37/python.exe
			else
				PYTHON3=/usr/bin/python3.7
			fi
		else
			PYTHON3=/usr/bin/python3
			install_debian_packages python3-venv python3-pip python3-setuptools python3-wheel
		fi
		"$PYTHON3" -m venv "$SCRIPT_DIR/venv"
		"$VENV/python" -m pip install setuptools==41.1.0 wheel==0.33.4
	fi
	if [ $# -ge 1 ] && [ -n "$1" ]; then
		if [ ! -e "$SCRIPT_DIR/venv/$1.installed" ]; then
			"$VENV/python" -m pip install -r "$SCRIPT_DIR/requirements_$1.txt"
			touch "$SCRIPT_DIR/venv/$1.installed"
		fi
	fi
	if [ -e "$(pwd)/requirements.txt" ]; then
		PRJ="$(basename "$(dirname "$(realpath "$0")")")"
		if [ ! -e "$SCRIPT_DIR/venv/${PRJ}.installed" ]; then
			"$VENV/python" -m pip install -r "$(pwd)/requirements.txt"
			touch "$SCRIPT_DIR/venv/${PRJ}.installed"
		fi
	fi
}
