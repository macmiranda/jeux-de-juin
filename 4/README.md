## Script Kiddies

Given a directory with the following structure:
```
dir/
  |----- 1/
  |      |---- key1
  |      |---- key2
  |      |---- key3
  |
  |----- 2/...
  |----- 3/...
  ...
  |----- N/...
```

* 1..N being a hex number
* the content of the file `key1` being `value1`, `key2` => `value2` and so on

Create a Bash one-liner using at least 2 of the following commands: `sed`, `awk`, `tr` and `grep`; that outputs a JSON object in the following format:

```
  {
    "1" : {
        "key1" : "value1",
        "key2" : "value2",
        "key3" : "value3"
    },
    "2" : {
        ...
    },
    "3" : {
        ...
    },
    ...
    "N" : {
        ...
    }
  }
```
The following requirements apply:

1. Values are ALWAYS strings.
1. Upper-case letters in values MUST be converted to lower-case.
1. Line breaks MUST be replaced by a literal '\n' (without the single quotes).
1. Empty lines MUST be removed.
1. Empty directories MUST be skipped.
1. Optionally, use the CLI utility `jq` for formatting.