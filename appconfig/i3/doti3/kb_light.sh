#!/usr/bin/env python3
# coding: utf-8

from sys import argv
import dbus
import subprocess

def sendmessage(value):
    string_message = "Keyboard brightness: %2.0f %%" % current_state

    if value < 0.1:
      string_message = "Keyboad brightness on MIN"
    elif value > 99.9:
      string_message = "Keyboad brightness on MAX"

    subprocess.Popen(['notify-send', string_message])
    return


def kb_light_set(delta):
    bus = dbus.SystemBus()
    kbd_backlight_proxy = bus.get_object('org.freedesktop.UPower', '/org/freedesktop/UPower/KbdBacklight')
    kbd_backlight = dbus.Interface(kbd_backlight_proxy, 'org.freedesktop.UPower.KbdBacklight')

    current = kbd_backlight.GetBrightness()
    maximum = kbd_backlight.GetMaxBrightness()
    new = max(0, current + delta)

    if new >= 0 and new <= maximum:
        current = new
        kbd_backlight.SetBrightness(current)

    # Return current backlight level percentage
    return 100 * current / maximum

if __name__ == '__main__':
    if len(argv[1:]) == 1:
        if argv[1] == "--up" or argv[1] == "+":
            # ./kb-light.py (+|--up) to increment
            current_state = kb_light_set(1)
            sendmessage(current_state)
            print(current_state)
        elif argv[1] == "--down" or argv[1] == "-":
            # ./kb-light.py (-|--down) to decrement
            current_state = kb_light_set(-1)
            sendmessage(current_state)
            print(current_state)
        else:
            print("Unknown argument:", argv[1])
    else:
        print("Script takes exactly one argument.", len(argv[1:]), "arguments provided.")
