#!/bin/bash

echo "CONSTANT program : mem_t := ("
cat | ./dcc | hexdump -v -e '4/1 "%02X" "\n"' | sed -e 's/.*/    x"&",/'
echo "    OTHERS => (OTHERS => '0'));"
