#!/bin/bash

echo DOMAIN=$DNS_DOMAIN >> /etc/sysconfig/network-scripts/ifcfg-ens3

rm -rf /var/lib/samba/private/*
rm -rf /var/lib/samba/sysvol/*

samba-tool domain provision \
  --use-rfc2307 \
  --realm=$AD_REALM \
  --domain=$AD_DOMAIN \
  --adminpass=$AD_PASSWORD \
  --server-role=dc \
  --dns-backend=SAMBA_INTERNAL

sed -i "5a ldap server require strong auth = no" /etc/samba/smb.conf

rm -f /etc/krb5.conf
ln -s /var/lib/samba/private/krb5.conf /etc/krb5.conf

samba-tool domain level show

touch /.docker/setup