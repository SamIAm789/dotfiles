{
  flake.modules.nixos.prometheus-server =
    { pkgs,
      ...
    }:
    {
      services.prometheus = {
        # Add this rule file without replacing existing scrape configs.
        ruleFiles = [
          (pkgs.writeText "node-alerts.yml" ''
            groups:
              - name: node-health
                rules:
                  - alert: CpuPackageTemperatureHigh
                    expr: |
                      node_hwmon_temp_celsius{
                        chip="platform_coretemp_0",
                        sensor="temp1"
                      } > 85
                    for: 5m
                    labels:
                      severity: warning
                    annotations:
                      summary: "CPU package temperature high"
                      description: "CPU package temperature on {{ $labels.instance }} is above 85°C."

                  - alert: NvmeTemperatureHigh
                    expr: |
                      node_hwmon_temp_celsius{
                        chip=~"nvme_nvme[01]",
                        sensor="temp1"
                      } > 70
                    for: 5m
                    labels:
                      severity: warning
                    annotations:
                      summary: "NVMe temperature high"
                      description: "NVMe temperature on {{ $labels.instance }} is above 70°C."

                  - alert: FilesystemSpaceWarning
                    expr: |
                      100 * (
                        1 -
                        node_filesystem_avail_bytes{
                          fstype!~"tmpfs|overlay|squashfs|ramfs",
                          mountpoint!=""
                        }
                        /
                        node_filesystem_size_bytes{
                          fstype!~"tmpfs|overlay|squashfs|ramfs",
                          mountpoint!=""
                        }
                      ) > 80
                    for: 5m
                    labels:
                      severity: warning
                    annotations:
                      summary: "Filesystem space running low"
                      description: "{{ $labels.instance }}: {{ $labels.mountpoint }} is over 80% full."

                  - alert: FilesystemSpaceCritical
                    expr: |
                      100 * (
                        1 -
                        node_filesystem_avail_bytes{
                          fstype!~"tmpfs|overlay|squashfs|ramfs",
                          mountpoint!=""
                        }
                        /
                        node_filesystem_size_bytes{
                          fstype!~"tmpfs|overlay|squashfs|ramfs",
                          mountpoint!=""
                        }
                      ) > 90
                    for: 5m
                    labels:
                      severity: critical
                    annotations:
                      summary: "Filesystem critically full"
                      description: "{{ $labels.instance }}: {{ $labels.mountpoint }} is over 90% full."

                  - alert: CpuUtilisationHigh
                    expr: |
                      100 * (
                        1 -
                        avg by (instance) (
                          rate(node_cpu_seconds_total{mode="idle"}[5m])
                        )
                      ) > 90
                    for: 10m
                    labels:
                      severity: warning
                    annotations:
                      summary: "CPU utilisation high"
                      description: "{{ $labels.instance }} CPU utilisation has exceeded 90% for 10 minutes."

                  - alert: AvailableMemoryLow
                    expr: |
                      100 *
                      node_memory_MemAvailable_bytes
                      /
                      node_memory_MemTotal_bytes < 10
                    for: 5m
                    labels:
                      severity: warning
                    annotations:
                      summary: "Available memory low"
                      description: "{{ $labels.instance }} has less than 10% memory available."

                  - alert: NodeExporterDown
                    expr: up{job="node"} == 0
                    for: 2m
                    labels:
                      severity: critical
                    annotations:
                      summary: "Node exporter unavailable"
                      description: "Prometheus cannot scrape {{ $labels.instance }}."
          '')
        ];
      };
    };
}
