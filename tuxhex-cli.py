mport argparse
from hacks import arp_scan, port_scan, wifi_deauth

parser = argparse.ArgumentParser(description='TuxHex CLI Tool')
subparsers = parser.add_subparsers(dest='command')


arp_parser = subparsers.add_parser('arp')
arp_parser.add_argument('target', help='Target subnet, e.g., 192.168.1.0/24')

port_parser = subparsers.add_parser('ports')
port_parser.add_argument('target', help='Target IP')
port_parser.add_argument('--ports', help='Comma-separated ports, e.g., 22,80,443')

deauth_parser = subparsers.add_parser('deauth')
deauth_parser.add_argument('target_mac', help='Target MAC Address')
deauth_parser.add_argument('--iface', default='wlan0', help='Interface')

args = parser.parse_args()

if args.command == 'arp':
    results = arp_scan(args.target)
    for device in results:
        print(f"{device['ip']} - {device['mac']}")

elif args.command == 'ports':
    ports = list(map(int, args.ports.split(','))) if args.ports else [22, 80, 443, 8080]
    open_ports = port_scan(args.target, ports)
    print(f"Open ports on {args.target}: {open_ports}")

elif args.command == 'deauth':
    print(f"Sending deauth to {args.target_mac} on {args.iface}")
    wifi_deauth(args.target_mac, args.iface)