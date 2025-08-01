#!/bin/sh

FILE="xpad.c"

# Comment XPAD_XBOXONE_VENDOR lines (except the #define)
sed -i '/#define[[:space:]]\+XPAD_XBOXONE_VENDOR/!s/^\([[:space:]]*\)\(XPAD_XBOXONE_VENDOR([^)]*)\)/\1\/\/\2/' "$FILE"

# Comment XTYPE_XBOXONE device entries
awk '
BEGIN { in_block = 0 }

/^\}[[:space:]]*xpad_device\[\][[:space:]]*=[[:space:]]*{/ { in_block = 1; print; next }
in_block && /^\}[[:space:]]*;/ { in_block = 0 }

{
    if (in_block && $0 ~ /{[^}]*XTYPE_XBOXONE[^}]*}/ && $0 !~ /^[[:space:]]*\/\//) {
        sub(/^([[:space:]]*)/, "&//")
    }
    print
}
' $FILE > $FILE.tmp && mv $FILE.tmp $FILE

