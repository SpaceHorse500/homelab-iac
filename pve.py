import os
import json
import requests
from urllib3.exceptions import InsecureRequestWarning

# === CONFIG (put your values here or use env vars below) ===
PM_API_URL = os.getenv("PM_API_URL", "https://192.168.1.96:8006/api2/json")
PM_API_TOKEN_ID = os.getenv("PM_API_TOKEN_ID", "tf@pve!tf-token")
PM_API_TOKEN_SECRET = os.getenv("PM_API_TOKEN_SECRET", "94f87aa6-f05d-4009-a50a-28f5a39ac5d8")
VERIFY_TLS = os.getenv("PM_VERIFY_TLS", "false").lower() == "true"  # false for homelab/self-signed

# Silence the noisy self-signed warning if VERIFY_TLS is False
if not VERIFY_TLS:
    requests.packages.urllib3.disable_warnings(category=InsecureRequestWarning)

HEADERS = {
    "Authorization": f"PVEAPIToken {PM_API_TOKEN_ID}={PM_API_TOKEN_SECRET}"
}

def get(path, params=None):
    url = f"{PM_API_URL.rstrip('/')}/{path.lstrip('/')}"
    r = requests.get(url, headers=HEADERS, verify=VERIFY_TLS, params=params, timeout=10)
    r.raise_for_status()
    return r.json()["data"]

def pretty(title, data):
    print(f"\n=== {title} ===")
    if isinstance(data, (list, dict)):
        print(json.dumps(data, indent=2))
    else:
        print(data)

def main():
    # 0) API version
    pretty("API version", get("version"))

    # 1) Cluster nodes
    nodes = get("nodes")
    pretty("Nodes", nodes)

    # 2) Cluster VMs/CTs
    vms = get("cluster/resources", params={"type": "vm"})
    # Trim to the most useful fields
    vms_view = [
        {
            "vmid": v.get("vmid"),
            "name": v.get("name"),
            "node": v.get("node"),
            "type": v.get("type"),
            "status": v.get("status"),
            "uptime": v.get("uptime"),
            "cpu": v.get("cpu"),
            "mem": v.get("mem"),
            "tags": v.get("tags"),
        }
        for v in vms
    ]
    pretty("VMs/CTs (cluster/resources?type=vm)", vms_view)

    # 3) Storage list
    storage = get("storage")
    pretty("Storage", storage)

    # 4) For each node, list QEMU VMs (and LXC if you want)
    for n in nodes:
        node = n["node"]
        try:
            qemu = get(f"nodes/{node}/qemu")
            pretty(f"QEMU on node {node}", [
                {"vmid": q["vmid"], "name": q.get("name"), "status": q.get("status")} for q in qemu
            ])
            # lxc = get(f"nodes/{node}/lxc")
            # pretty(f"LXC on node {node}", [{"vmid": c["vmid"], "name": c.get("name"), "status": c.get("status")} for c in lxc])
        except requests.HTTPError as e:
            print(f"[WARN] Could not list VMs on node {node}: {e}")

    # 5) Example: get a single VM status if you know the VMID (change 100)
    # vm_status = get("nodes/pve/qemu/100/status/current")
    # pretty("VM 100 status", vm_status)

    print("\nDone.")

if __name__ == "__main__":
    main()
