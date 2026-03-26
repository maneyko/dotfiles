#!/usr/bin/env python3

# vim: ft=python

from datetime import datetime
import math


def convert_gmt_to_utc(iso):
    if iso.endswith("00:00"):
        iso = iso[:19] + "Z"
    return iso

def unix_time_to_iso8601(ts_str):
    if not ts_str.replace(".", "").isdigit():
        raise ValueError(f"Argument {ts_str!r} contains invalid characters")

    seconds_int_str, fractional_str = ts_str[:10], ts_str[10:]

    dt = datetime.fromtimestamp(int(seconds_int_str)).astimezone()

    if len(fractional_str) == 0:
        return convert_gmt_to_utc(dt.isoformat())

    if fractional_str.startswith("."):  # 1762786902.123
        fractional_int_str = fractional_str[1:]
        if len(fractional_int_str) == 0:  # 1762786902.
            fractional_int_str = "0"
    else:  # 1762786902123
        fractional_int_str = fractional_str

    fractional_format_len = math.ceil(len(fractional_int_str) / 3) * 3

    zero_count = fractional_format_len - len(fractional_int_str)

    iso = dt.strftime("%FT%T") + "." + fractional_int_str + "0" * zero_count + dt.strftime("%:z")

    return convert_gmt_to_utc(iso)

def main():
    import sys
    argv = sys.argv[1:]
    if len(argv) == 0:
        basename = __file__.split("/")[-1]
        print(f"Usage: {basename} <timestamp>")
        sys.exit(1)

    iso = unix_time_to_iso8601(argv[0])
    print(iso)

if __name__ == "__main__":
    main()
