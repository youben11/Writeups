#!/usr/bin/python3

import subprocess
import socket
import re
from time import sleep
from binascii import hexlify

# connect to the challenge service
server = ('rev.chal.csaw.io', 9004)
s = socket.socket()
s.connect(server)
print(s.recv(4096))

# assemble our payload
subprocess.run(["nasm", "payload.nasm", "-o" ,"payload"])
# getting our payload with the right format
payload = open("payload", "rb").read().strip()
payload = hexlify(payload)
# send it to be executed
s.send(payload + b'\n')
# get response from the server
resp = s.recv(4096)
# getting the port number for the vnc
port = int(re.findall(r'port (\d+)', str(resp))[0])
server = (server[0], port)
print("[+] Starting vnc on port %d" % port)
# starting the vnc to get the flag
subprocess.run(["vncviewer", "rev.chal.csaw.io:%d" % port])


