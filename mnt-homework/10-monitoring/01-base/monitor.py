#!/usr/bin/env python3

# Aleksei Shtepa
# Netology homework mnt-10.01

from datetime import date, datetime
import json
from time import sleep

# PATH_LOGS = "."
PATH_LOGS = "/var/log"
LOG_FILE_POSTFIX = "-awesome-monitoring.log"


def get_loadavg():
    with open("/proc/loadavg", "r") as f:
        t1, t5, t15, process, _ = f.read().split()
        return {
            "t1": t1,
            "t5": t5,
            "t15": t15,
            "process_deque": process.split("/")[0],
            "process_all": process.split("/")[1]
        }


def get_nproc():
    nproc = 0
    with open("/proc/cpuinfo", "r") as f:
        nproc = f.read().count("processor")
    return nproc
        

def get_cpu_stat():
    u = 0
    n = 0
    s = 0
    i = 0
    with open("/proc/stat", "r") as f:
        _, U0, N0, S0, I0, _, _, _, _, _, _ = f.readline().split()
        u = int(U0)
        n = int(N0)
        s = int(S0)
        i = int(I0)

    sleep(1)

    with open("/proc/stat", "r") as f:
        _, U0, N0, S0, I0, _, _, _, _, _, _ = f.readline().split()
        Ud = u - int(U0)
        Nd = n - int(N0)
        Sd = s - int(S0)
        Id = i - int(I0)
        total = Ud + Nd + Sd +Id
        avg_load = int(100 * (Ud + Nd + Sd)/total)
        return avg_load


def get_mem_info():
    with open("/proc/meminfo", "r") as f:
        total = f.readline().split()[1]
        free = f.readline().split()[1]
        available = f.readline().split()[1]
        return {"total": total, "free": free, "available": available}


def main():
    log = dict()
    log['timestamp'] = int(datetime.now().timestamp())
    log['host_avg_load'] = get_loadavg()
    log['nproc'] = get_nproc()
    log['ram'] = get_mem_info()
    log['cpu_avg_load'] = get_cpu_stat()
    with open(f"{PATH_LOGS}/{date.today().strftime('%y-%m-%d')}{LOG_FILE_POSTFIX}", "a") as f:
        f.write(json.dumps(log))
        f.write("\n")


if __name__ == "__main__":
    main()