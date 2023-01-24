#!/bin/bash

#Run this on the folder you want to change the permissions on directly
#755 for directories
#644 for files

find ./  -type d -exec chmod 755 {} \;
find ./ -type f -exec chmod 644 {} \;
