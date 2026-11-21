Tesla BLE and TWCManager – Backup & Restore Guide

Backup location

The verified backup is stored on the NixOS server:

/stuff/backups/tesla-ble-complete-2026-11-21-151832.tar.gz

The archive contains private Tesla BLE keys. Keep it secure and maintain an additional copy on separate storage.

1. What's included

File or directory| Contents
"/etc/twcmanager/"| TWCManager configuration, vehicle settings and converted BLE keys
"/home/sam/teslable/data/"| Original TeslaBLEMQTT private/public keys, accepted-key markers, MAC addresses and presence data
"/home/sam/teslable/docker-compose.yml"| TeslaBLEMQTT Docker configuration
"/home/sam/twcmanager/docker-compose.yml"| TWCManager Docker configuration

Both vehicles' existing BLE identities are preserved. The TWCManager keys were converted from the original TeslaBLEMQTT keys and verified to match.

2. Requirements for a fresh Raspberry Pi installation

After reinstalling Linux, restore the following prerequisites:

- Create the "sam" user.
- Install Docker Engine and the Docker Compose plugin.
- Install and enable BlueZ Bluetooth services.
- Ensure D-Bus is running.
- Reconnect the Bluetooth adapter.
- Reconnect the Tesla Wall Connector's USB/RS485 adapter, if applicable.

The TWCManager Compose configuration expects access to the host's Bluetooth D-Bus socket and "/dev/ttyUSB0".

Check the host services:

sudo systemctl status dbus
sudo systemctl status bluetooth
bluetoothctl show

3. Copy the backup to the Raspberry Pi

From the Raspberry Pi:

scp sam@10.25.0.24:/stuff/backups/tesla-ble-complete-2026-11-21-151832.tar.gz ~/

Replace the server address or filename if either has changed.

4. Stop existing containers

If Docker containers already exist, stop them before restoring configuration:

sudo docker stop twcmanager-twcmanager-1 tesla_ble_mqtt

If the containers don't exist yet, this step can be skipped.

5. Restore the backup

Extract the archive into the root filesystem:

sudo tar -xzpf ~/tesla-ble-complete-2026-11-21-151832.tar.gz -C /

This restores the original directory structure, including:

/etc/twcmanager/
/home/sam/teslable/
/home/sam/twcmanager/

The archive was created with permissions and ownership preserved. Avoid recursively changing ownership unless you have first checked what the restored files require.

6. Start TeslaBLEMQTT

cd ~/teslable
sudo docker compose up -d

Check that it starts:

sudo docker ps
sudo docker logs --tail 50 tesla_ble_mqtt

7. Start TWCManager

cd ~/twcmanager
sudo docker compose up -d

Check the logs:

sudo docker logs --tail 100 twcmanager-twcmanager-1

Look for:

- TeslaBLE module initialisation.
- "tesla-control" binary found.
- Bluetooth controller access succeeding.
- Both vehicle entries being loaded.

8. Verify the restored keys

TWCManager's vehicle keys should still match the original TeslaBLEMQTT public keys.

Do not initiate pairing or add new keys.

When one of the Teslas is physically nearby, test an actual BLE operation first. A successful connection will confirm that the restored keys and Bluetooth setup work together.

9. Important notes

This archive does not include:

- The Raspberry Pi operating system.
- Docker images (these are downloaded again when starting the containers).
- Host-level Bluetooth or D-Bus configuration.
- Other files outside the paths listed above.

The restore instructions assume the original username ("sam") and directory structure are retained.

Do not delete the TeslaBLEMQTT keys or accepted-key marker files. They are the original known-working vehicle credentials and are also the source of TWCManager's converted keys.

Backup security

The archive contains private vehicle credentials. Keep it private, preferably on encrypted storage, and do not upload it to an untrusted service.

The server copy currently has restrictive file permissions ("600").