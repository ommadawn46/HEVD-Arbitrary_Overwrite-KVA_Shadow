import sys

TAB = 4
MAX_LINE_LENGTH = 80

with open(sys.argv[1], "rb") as file:
    data = file.read()

print(f"// size: {len(data)}")
print("unsigned char rawShellcode[] = {")

formatted_hex = [f"0x{byte:02x}" for byte in data]
line = " " * TAB

for hex_value in formatted_hex:
    if len(line + hex_value + ",") > MAX_LINE_LENGTH:
        print(line.rstrip())
        line = " " * TAB
    line += hex_value + ", "

print(line.rstrip(", ") + "\n};")
