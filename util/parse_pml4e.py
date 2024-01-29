import argparse


def parse_pml4e(pml4e):
    # ref: https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html
    bit_descriptions = {
        0: "Present",
        1: "Read/Write",
        2: "User/Supervisor",
        3: "Page-Level Write-Through",
        4: "Page-Level Cache Disable",
        5: "Accessed",
        63: "Execute Disable",
    }

    output = []
    output.append(f"PML4E: {pml4e:064b}")

    for bit in bit_descriptions:
        status = "Set" if (pml4e >> bit) & 1 else "Not Set"
        output.append(f"Bit {bit:2}: {bit_descriptions[bit]:30} - {status}")

    pfn = (pml4e >> 12) & 0xFFFFFFFFFF
    output.append(f"Physical Frame Number (PFN): {pfn:#x}")

    return "\n".join(output)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "pml4e", help="PML4E in hexadecimal format.", type=lambda x: int(x, 16)
    )
    args = parser.parse_args()

    try:
        parsed_pml4e = parse_pml4e(args.pml4e)
        print(parsed_pml4e)
    except ValueError as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    main()
