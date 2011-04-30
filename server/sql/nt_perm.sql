# vim: set expandtab ts=4:
#
# $Id: nt_perm.sql,v 1.2 2004/10/05 00:09:26 matt Exp $
#
# NicTool v2.00-rc1 Copyright 2001 Damon Edwards, Abe Shelton & Greg Schueler
# NicTool v2.01 Copyright 2004 The Network People, Inc.
#
# NicTool is free software; you can redistribute it and/or modify it under 
# the terms of the Affero General Public License as published by Affero, 
# Inc.; either version 1 of the License, or any later version.
#
# NicTool is distributed in the hope that it will be useful, but WITHOUT 
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
# or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GPL for details.
#
# You should have received a copy of the Affero General Public License
# along with this program; if not, write to Affero Inc., 521 Third St,
# Suite 225, San Francisco, CA 94107, USA
#

DROP TABLE IF EXISTS nt_perm;
CREATE TABLE nt_perm(
    nt_perm_id          INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nt_group_id         INT UNSIGNED DEFAULT NULL,
    nt_user_id          INT UNSIGNED DEFAULT NULL,
    inherit_perm        INT UNSIGNED DEFAULT NULL,
    perm_name           VARCHAR(50),

    group_write             TINYINT UNSIGNED NOT NULL DEFAULT 0,
    group_create            TINYINT UNSIGNED NOT NULL DEFAULT 0,
    #group_delegate          TINYINT UNSIGNED NOT NULL DEFAULT 0,
    group_delete            TINYINT UNSIGNED NOT NULL DEFAULT 0,

    zone_write              TINYINT UNSIGNED NOT NULL DEFAULT 0,
    zone_create             TINYINT UNSIGNED NOT NULL DEFAULT 0,
    zone_delegate           TINYINT UNSIGNED NOT NULL DEFAULT 0,
    zone_delete             TINYINT UNSIGNED NOT NULL DEFAULT 0,

    zonerecord_write        TINYINT UNSIGNED NOT NULL DEFAULT 0,
    zonerecord_create       TINYINT UNSIGNED NOT NULL DEFAULT 0,
    zonerecord_delegate     TINYINT UNSIGNED NOT NULL DEFAULT 0,
    zonerecord_delete       TINYINT UNSIGNED NOT NULL DEFAULT 0,
    
    user_write              TINYINT UNSIGNED NOT NULL DEFAULT 0,
    user_create             TINYINT UNSIGNED NOT NULL DEFAULT 0,
    user_delete             TINYINT UNSIGNED NOT NULL DEFAULT 0,

    nameserver_write        TINYINT UNSIGNED NOT NULL DEFAULT 0,
    nameserver_create       TINYINT UNSIGNED NOT NULL DEFAULT 0,
    nameserver_delete       TINYINT UNSIGNED NOT NULL DEFAULT 0,

    self_write              TINYINT UNSIGNED NOT NULL DEFAULT 0,

    usable_ns0      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns1      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns2      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns3      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns4      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns5      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns6      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns7      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns8      SMALLINT UNSIGNED NOT NULL DEFAULT '0',
    usable_ns9      SMALLINT UNSIGNED NOT NULL DEFAULT '0',

    deleted             ENUM('0','1') DEFAULT '0' NOT NULL
);
CREATE INDEX nt_perm_idx1 on nt_perm(nt_group_id,nt_user_id);
CREATE INDEX nt_perm_idx2 on nt_perm(nt_user_id);

INSERT into nt_perm VALUES(1,1,0,NULL,NULL,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,0,0,0,0,0,0,0,0,'0');

DROP TABLE IF EXISTS nt_delegate;
CREATE TABLE nt_delegate(
    #nt_delegate_id      INT UNSIGNED AUTO_INCREMENT NOT NULL PRIMARY KEY,
    nt_group_id         INT UNSIGNED NOT NULL,
    nt_object_id        INT UNSIGNED NOT NULL,
    nt_object_type      ENUM('ZONE','ZONERECORD','NAMESERVER','USER','GROUP') NOT NULL ,
    delegated_by_id     INT UNSIGNED NOT NULL,
    delegated_by_name     VARCHAR(50),


    perm_write          TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    perm_delete         TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    perm_delegate       TINYINT UNSIGNED DEFAULT 1 NOT NULL,

    zone_perm_add_records           TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_delete_records        TINYINT UNSIGNED DEFAULT 1 NOT NULL,

    # more specific access perms --- not used yet

    zone_perm_modify_zone           TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_mailaddr       TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_desc           TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_minimum        TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_serial         TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_refresh        TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_retry          TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_expire         TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_ttl            TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_nameservers    TINYINT UNSIGNED DEFAULT 1 NOT NULL,

    zonerecord_perm_modify_name     TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_type     TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_addr     TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_weight   TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_ttl      TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_desc     TINYINT UNSIGNED DEFAULT 1 NOT NULL,

    #delegating groups: not implemented yet
    #group_perm_modify_name              TINYINT UNSIGNED DEFAULT 1 NOT NULL, 
    
    deleted             ENUM('0','1') DEFAULT '0' NOT NULL
);
CREATE INDEX nt_delegate_idx1 on nt_delegate(nt_group_id,nt_object_id,nt_object_type);
CREATE INDEX nt_delegate_idx2 on nt_delegate(nt_object_id,nt_object_type);


DROP TABLE IF EXISTS nt_delegate_log; 
CREATE TABLE nt_delegate_log(
    nt_delegate_log_id              INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nt_user_id                      INT UNSIGNED NOT NULL,
    nt_user_name                    VARCHAR(50),
    action                          ENUM('delegated','modified','deleted') NOT NULL,
    nt_object_type                  ENUM('ZONE','ZONERECORD','NAMESERVER','USER','GROUP') NOT NULL ,
    nt_object_id                    INT UNSIGNED NOT NULL,
    nt_group_id                     INT UNSIGNED NOT NULL,
    timestamp                       INT UNSIGNED NOT NULL,

    perm_write                      TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    perm_delete                     TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    perm_delegate                   TINYINT UNSIGNED DEFAULT 1 NOT NULL,

    zone_perm_add_records           TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_delete_records        TINYINT UNSIGNED DEFAULT 1 NOT NULL,

    # more specific access perms --- not used yet

    zone_perm_modify_zone           TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_mailaddr       TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_desc           TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_minimum        TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_serial         TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_refresh        TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_retry          TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_expire         TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_ttl            TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zone_perm_modify_nameservers    TINYINT UNSIGNED DEFAULT 1 NOT NULL,

    zonerecord_perm_modify_name     TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_type     TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_addr     TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_weight   TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_ttl      TINYINT UNSIGNED DEFAULT 1 NOT NULL,
    zonerecord_perm_modify_desc     TINYINT UNSIGNED DEFAULT 1 NOT NULL

    #delegating groups: not implemented yet
    #group_perm_modify_name         TINYINT UNSIGNED DEFAULT 1 NOT NULL, 
);

