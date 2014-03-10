# Omnis::Agent

## NOTICE

Omnis::Agent is **still ALPHA quality**. **Any API will change without notice**.

## About

Omnis::Agent provides following HTTP API, by running on each of servers.

- returns system metrics
    - memory, CPU usage and so on, like SNMP
- manupulate files/directories
    - returns information on a file/directory
    - returns content of a file/directory
    - creates and deletes a file/directory
- performs command and returns that result (STDOUT/STDERR)
    - like RPC

## Quick Start

```
git clone https://github.com/Omnis-System/Omnis-Agent.git
cd Omnis-Agent
cpanm -L extlib --installdeps .

perl script/omnis-agent --host 127.0.0.1
```

Omnis::Agent listens 4649 port by default.


### Retrieve System Metrics

```
curl http://127.0.0.1:4649/metric/memory
{
  "swap": {
    "total": 1959784448,
    "used": 0,
    "free": 1959784448
  },
  "memory": {
    "cached": 4621635584,
    "total": 16817000448,
    "used": 6047027200,
    "inactive": 2960449536,
    "free": 7809523712,
    "buffers": 1749143552
  }
}
```

### Manupulate files/directories

Retrieve information of specified file:
```
curl http://127.0.0.1:4649/fs/etc/passwd?stat
{
  "gid": 0,
  "type": "file",
  "user": "root",
  "group": "root",
  "nlink": 1,
  "size": 2417,
  "blksize": 4096,
  "ctime": 1383634873,
  "blocks": 8,
  "uid": 0,
  "mode": "0644",
  "mtime": 1383634873,
  "status": 200,
  "path": "/etc/passwd"
}
```

Retrieve with content of specified file:
```
curl http://127.0.0.1:4649/fs/etc/passwd
{
  "gid": 0,
  "type": "file",
  "user": "root",
  "group": "root",
  "nlink": 1,
  "size": 2417,
  "path": "/etc/passwd",
  "blksize": 4096,
  "ctime": 1383634873,
  "blocks": 8,
  "uid": 0,
  "mode": "0644",
  "mtime": 1383634873,
  "status": 200,
  "content": [
    "root:x:0:0:root:/root:/bin/bash\n",
    ...
  ]
}
```

Create a new file:
```
echo 'Hello, Omnis!' | curl -X PUT -T - http://127.0.0.1:4649/fs/tmp/test
{
  "path": "/tmp/test",
  "status": 200
}

 curl http://127.0.0.1:4649/fs/tmp/test
{
  "gid": 2050,
  "type": "file",
  "user": "hirose31",
  "group": "hirose31",
  "nlink": 1,
  "size": 14,
  "path": "/tmp/test",
  "blksize": 4096,
  "ctime": 1394441342,
  "blocks": 8,
  "uid": 2050,
  "mode": "0664",
  "mtime": 1394441342,
  "status": 200,
  "content": [
    "Hello, Omnis!\n"
  ]
}
```

### perform command on that server

specify an absolute path of command:
```
curl http://127.0.0.1:4649/cmd/bin/date
{
  "stdout": [
    "Mon Mar 10 17:49:53 JST 2014\n"
  ],
  "path": "/bin/date",
  "status": 200,
  "stderr": []
}
```

or can search in ```$PATH```:
```
curl http://127.0.0.1:4649/cmd/date
{
  "stdout": [
    "Mon Mar 10 17:49:53 JST 2014\n"
  ],
  "path": "/bin/date",
  "status": 200,
  "stderr": []
}
```

with arguments:
```
curl 'http://127.0.0.1:4649/cmd/bin/date?arg=--rfc-3339=seconds'
{
  "stdout": [
    "2014-03-10 17:51:46+09:00\n"
  ],
  "path": "/bin/date",
  "status": 200,
  "stderr": []
}
```


