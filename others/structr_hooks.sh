#!/bin/bash

name="structr"

export PATH=$PATH:/srv/cloudlabs/scripts

# Getting the doc and styles
wget -q -N --timeout=2 https://raw.githubusercontent.com/terminalcloud/apps/master/docs/"$name".md
wget -q -N --timeout=2 https://raw.githubusercontent.com/terminalcloud/apps/master/docs/termlib.css

# Making the file...
cat > /root/info.html << EOF
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" type="text/css"href="termlib.css" />
<p id="exlink"><a id="exlink" target="_blank" href="http://$(hostname)-8082.terminal.com/structr#pages"><b>Check your installation here!</b></a></p>
<p id="ac"><a id="ac"target="_blank" href="http://$(hostname).terminal.com"/home/root/info.html>links not working?</a>
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


# Showing up
cat | /srv/cloudlabs/scripts/run_in_term.js << EOF
/srv/cloudlabs/scripts/display.sh /root/info.html
EOF