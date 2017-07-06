#!/bin/sh

# copyright: (c) 2014 by Josh "blacktop" Maine.
# license: MIT

if ls /nsrl/*.zip 1> /dev/null 2>&1; then
   echo "File '.zip' Exists."
else
    echo "[INFO] Downloading NSRL Reduced Sets..."
    NSRL_URL="http://www.nsrl.nist.gov/"
    MIN_SET=$(wget -O - ${NSRL_URL}Downloads.htm 2> /dev/null | \
      grep -m 1  "Minimal set" | \
      grep -o '<a href=['"'"'"][^"'"'"']*['"'"'"]' | \
      sed -e 's/^<a href=["'"'"']//' -e 's/["'"'"']$//')
    wget -P /nsrl/ $NSRL_URL$MIN_SET 2> /dev/null
fi

echo "[INFO] Unzip NSRL Database zip to /nsrl/ ..."
7za x -o/nsrl/ /nsrl/*.zip

echo "[INFO] Build bloomfilter from NSRL Database ..."
cd /nsrl && /bin/nsrl --verbose build

echo "[INFO] Listing created files ..."
ls -lah /nsrl

echo "[INFO] Saving uncompressed NSRL DB size..."
ls -lah NSRLFile.txt | awk '{print $5}' > /nsrl/DBSZIE

echo "[INFO] Saving bloomfilter size..."
ls -lah nsrl.bloom | awk '{print $5}' > /nsrl/BLOOMSIZE

echo "[INFO] Deleting all unused files ..."
rm -f *.zip *.txt *.sh
ls -lah /nsrl
