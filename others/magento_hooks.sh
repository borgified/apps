#!/bin/bash

name="magento"

export PATH=$PATH:/srv/cloudlabs/scripts

# Update URL in database
mysql -uroot -proot magento -e"UPDATE mg_core_config_data set value = 'http://$(hostname)-80.terminal.com/' where config_id = 6;"
mysql -uroot -proot magento -e"UPDATE mg_core_config_data set value = 'http://$(hostname)-80.terminal.com/' where config_id = 7;"

# Clean bad Cache files
rm -r /var/www/magento/var/cache/*
rm -r /var/www/magento/var/session/*

# Getting the doc and styles
wget -q -N --timeout=2 https://raw.githubusercontent.com/terminalcloud/apps/master/docs/"$name".md
wget -q -N --timeout=2 https://raw.githubusercontent.com/terminalcloud/apps/master/docs/termlib.css && mv termlib.css /root/


# Making the file...
cat > /root/info.html << EOF
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css" href="termlib.css" />
<p id="exlink"><a id="exlink" target="_blank" href="http://$(hostname)-80.terminal.com/"><b>Magento Frontend</b></a></p>
<p id="exlink"><a id="exlink" target="_blank" href="http://$(hostname)-80.terminal.com/admin"><b>Magento Administration</b></a></p>
</head>
<body>
EOF

# Converting markdown file
markdown "$name.md" >> /root/info.html

# Closing file
cat >> /root/info.html << EOF
</body>
</html>
EOF

# Convert links to external links
sed -i 's/a\ href/a\ target\=\"\_blank\"\ href/g' /root/info.html 

# Update server URL in Docs
sed -i "s/terminalservername/$(hostname)/g" /root/info.html


# Open a new terminal
echo | /srv/cloudlabs/scripts/run_in_term.js

# Showing up
cat | /srv/cloudlabs/scripts/run_in_term.js	 << EOF
/srv/cloudlabs/scripts/display.sh /root/info.html
EOF