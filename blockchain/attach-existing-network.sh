#!/bin/bash
geth --exec "loadScript(\"$1\")" attach http://172.31.37.80:22000
