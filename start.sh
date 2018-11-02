#!/bin/bash
cd /root/hg/pyogp.apps/pyogp/apps/examples
sudo -u pyogp python region_connect.py $SL_FIRSTNAME $SL_SURNAME --password "$SL_PASSWORD" --region "$SL_REGION"
