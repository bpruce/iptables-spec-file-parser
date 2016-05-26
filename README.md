# iptables-spec-file-parser
Bash script which takes iptables list by specification with appended file path and parses out important information. 


Basic structure of rules is below: 

--append INPUT -p tcp --match multiport --dports 80,443 -m state --state NEW -j ACCEPT ../firewalls/test1

A directory stores every node's iptables rules from a clustered environment.  An upstream script pulls down relevant iptables rules and appends the directory and node name to the end of the file.  This script will take that information and crop off all the garbage to make a simple 4 column table 

Protocol srcip port nodename
