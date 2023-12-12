#!/usr/bin/env python3.8.exe
""" enumSerial.py

example of midi output.

By default it runs the output example.

python midi_kick.py --find
python midi_kick.py --kick
python midi_kick.py --loop
python midi_kick.py --list

"""

import sys
import os
import serial.tools.list_ports
from signal import signal, SIGINT
from time import sleep
from contextlib import redirect_stdout

# Suppress a silly banner that pygame sends to stdout on load
with open(os.devnull, 'w') as devnull:
	with redirect_stdout(devnull):
		from pygame.midi import init, quit, get_count, get_device_info, Output


def print_midi_device_info():
    init()
    _print_midi_device_info()
    quit()

def get_serial_device_list(all_the_ports = False):
	ports = serial.tools.list_ports.comports()
	port_list = []
	for p in ports:
		if p.vid or all_the_ports:
			port_list.append(p)
	return port_list

def print_serial_device_info(all_the_ports = True):
	ports = get_serial_device_list(all_the_ports)
	for i in range(len(ports)):
		if ports[i].vid:
			vid = int(ports[i].vid)
		else:
			vid = 0
		if (vid == 0 and not all_the_ports):
			continue
		print(
			"%2i: %-8s - :%-21s: 0x%04x"
			% (i, ports[i].name, ports[i].manufacturer, vid )
		)

def _print_midi_device_info():
    for i in range(get_count()):
        r = get_device_info(i)
        (interf, name, input, output, opened) = r
        name = "'" + str(name, encoding='utf-8').strip() + "'"

        in_out = ""
        if input:
            in_out = "(input)"
        if output:
            in_out = "(output)"

        print(
            "%2i: %-19s - :%s:  %s"
            % (i, name, "open " if opened else "avail", in_out)
        )

def find_id(target='Teensy MIDI'):
	init()
	for d in range( get_count() ):
		(interf, name, input, out, op) = get_device_info(d)
		name = str(object=name, encoding='utf-8')
		if (name.startswith( target ) and out == 1):
			return d
	quit()
	return None

def device_name(id):
	(interf, name, inp, outp, op) = get_device_info(id)
	return str(object=name, encoding='utf-8')

def kickit():
	port = find_id()
	if (port):
		print("kick on", device_name(port))
		midi_out = Output(port, 0)
		# Midi raw channel 9 is percussion, most people call it channel 10
		# pygame passes channel number verbatim
		midi_out.note_on(36, 101, channel=9)
		sleep(0.05)
		midi_out.note_off(36, channel=9)
		quit()
	else:
		print("no teensy MIDI available")

def exit_handler(signum, frame):
	print('\nThank you and good-night!\n')
	exit(0)

def loopit():
	signal(SIGINT, exit_handler)
	while True:
		kickit()
		sleep(5.0)


def usage():
    print("--kick : send kick note on / off")
    print("--loop : loop, sending kick every 5 sec")
    print("--list : list available midi devices and com ports")
    print("--find : just check for teensy MIDI device")


if __name__ == "__main__":

    if "--find" in sys.argv or "-f" in sys.argv:
        teensy = find_id()
        if (teensy):
            print("teensy MIDI is device", find_id())
        else:
            print("teensy MIDI is not available")
    elif "--kick" in sys.argv or "-k" in sys.argv:
        kickit()
    elif "--list" in sys.argv or "-l" in sys.argv:
        print("MIDI Ports:")
        print_midi_device_info()
        print("\nSerial Ports:")
        print_serial_device_info()
    elif "--loop" in sys.argv or "-o" in sys.argv:
        loopit()
    elif "--monitor" in sys.argv or "-m" in sys.argv:
        dev = get_serial_device_list(False)
        if dev:
            print("arduino-cli.exe monitor -p ", dev[0].name)
    elif "--help" in sys.argv or "-h" in sys.argv:
        usage()
    else:
        print_serial_device_info(False)
