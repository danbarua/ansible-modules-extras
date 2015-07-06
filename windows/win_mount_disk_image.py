#!/usr/bin/python
# -*- coding: utf-8 -*-

# (c) 2015, Dan Barua <danbarua@gmail.com>
#
# This file is part of Ansible
#
# Ansible is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Ansible is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Ansible.  If not, see <http://www.gnu.org/licenses/>.

# this is a windows documentation stub.  actual code lives in the .ps1
# file of the same name

DOCUMENTATION = '''
---
module: win_mount_disk_image
version_added: ""
short_description: Mounts a previously created disk image (virtual hard disk or ISO), making it appear as a normal disk.
description:
     -The Mount-DiskImage cmdlet mounts a previously created disk image (virtual hard disk or ISO), making it appear as a normal disk.
options:
  file:
    description:
      - Specifies the path of the VHD or ISO file.
    required: yes
    default: none
    aliases: []
  state:
    description:
      - Specify whether to mount (present) or dismount (absent)
    required: no
    choices:
      - present
      - absent
    default: present
    aliases: []
author: Dan Barua
'''

EXAMPLES = '''
# Mount an ISO
$ ansible -i hosts -m win_mount_disk_image -a "file='c:/my_iso.iso'" all
# Playbook example
# Mount an ISO file
---
- name: mount iso
  win_mount_disk_image:
   file: c:/vagrant/playbook/files/en_sql_server_2008_r2_standard_x86_x64_ia64_dvd_521546.iso
   state: present
   register: mount_result

- debug: var=mount_result #mount_result.volume.drive_letter contains the drive letter of the mounted volume

# Dismount an ISO file
---
- name: mount iso
  win_mount_disk_image:
   file: c:/vagrant/playbook/files/en_sql_server_2008_r2_standard_x86_x64_ia64_dvd_521546.iso
   state: absent
'''