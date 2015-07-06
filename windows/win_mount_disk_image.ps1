#!powershell
# This file is part of Ansible
#
# Copyright 2015, Dan Barua <danbarua@gmail.com>
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

# WANT_JSON
# POWERSHELL_COMMON


$params = Parse-Args $args;

$result = New-Object psobject @{
    changed = $false
}

Write-Output $params

if (-not $params.file){
    Fail-Json $result "missing required argument: file"
}
else{

    $file = $params.file

    if ($params.state -eq "present") {
        $state = $true
        Set-Attr $result.win_mount_disk_image "state" "present"
    }
    ElseIf ($params.state -eq "absent") {
        $state = $false
        Set-Attr $result.win_mount_disk_image "state" "absent"
    }
    Else {
        $state = "none"
    }

    try{
        if ($state) {
            $mountResult = Get-DiskImage -ImagePath $params.file -ErrorAction SilentlyContinue

            if ($mountResult.Attached -eq $false){
                $mountResult = Mount-DiskImage -ImagePath $params.file -PassThru -ErrorAction Stop
                $result.changed = $true
            }
            $volume = ($mountResult | Get-Volume)

            $result.volume =  New-Object psobject
            Set-Attr $result.volume "drive_letter" $volume.DriveLetter
            Set-Attr $result.volume "drive_type" $volume.DriveType
            Set-Attr $result.volume "size" $volume.Size
            Set-Attr $result.volume "image_path" $mountResult.ImagePath

            $result.state = "present"
        }
        else {
            $mountResult = Get-DiskImage -ImagePath $params.file -ErrorAction SilentlyContinue

            if ($mountResult.Attached -eq $false){
                $result.changed = $false
            }
            else {  
                Dismount-DiskImage -ImagePath $file -ErrorAction Stop
                $result.changed = $true
            }
            
            $result.state = "absent"
        }

        
    }
    catch
    {
      Fail-Json $result $_.Exception.Message
    }

}

Exit-Json $result