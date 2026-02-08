#!/bin/bash
# =========================================
# CPU & SMT Info Checker
# 输出 CPU 拓扑、SMT 状态、Cache 信息、NUMA 节点
# =========================================

echo "=== CPU & SMT Info Checker ==="
echo

# 基本 CPU 信息
echo "-- Basic CPU Info --"
lscpu | grep -E "Architecture|CPU\(s\)|Thread|Core|Socket|NUMA|Model name"
echo

# SMT 状态
SMT_DIR="/sys/devices/system/cpu/smt"
if [ -d "$SMT_DIR" ]; then
    echo "-- SMT Status --"
    if [ -f "$SMT_DIR/active" ]; then
        SMT_ACTIVE=$(cat $SMT_DIR/active)
        if [ "$SMT_ACTIVE" -eq 1 ]; then
            echo "SMT is ACTIVE"
        else
            echo "SMT is INACTIVE"
        fi
    fi
    echo
fi

# CPU -> Core 映射
echo "-- CPU -> Core Mapping --"
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
    CPU_NAME=$(basename $cpu)
    CORE_ID=$(cat $cpu/topology/core_id)
    SOCKET_ID=$(cat $cpu/topology/physical_package_id)
    echo "$CPU_NAME: core=$CORE_ID, socket=$SOCKET_ID"
done | sort -t= -k2n
echo

# NUMA 节点信息
echo "-- NUMA Node Info --"
if command -v lscpu >/dev/null 2>&1; then
    lscpu -e=CPU,NODE | column -t
fi
echo

# Cache 信息
echo "-- Cache Info (per CPU) --"
for cpu in /sys/devices/system/cpu/cpu[0-9]*; do
    CPU_NAME=$(basename $cpu)
    echo "$CPU_NAME caches:"
    for cache in $cpu/cache/index*; do
        LEVEL=$(cat $cache/level)
        TYPE=$(cat $cache/type)
        SIZE=$(cat $cache/size)
        echo "  L$LEVEL $TYPE cache: $SIZE"
    done
done
echo

echo "=== End of Report ==="
