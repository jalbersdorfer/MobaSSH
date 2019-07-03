[![Build status](https://ci.appveyor.com/api/projects/status/5up6pp2sd3bh7lx9?svg=true)](https://ci.appveyor.com/project/jalbersdorfer/mobassh/build/artifacts)

# MobaSSH

Start (multiple) SSH Sessions in MobaXterm from Commandline and optionally run an initial command.

# Prequesits

- MobaXterm.exe on PATH
- a `.ssh/mobassh.user` file containing the username to use for SSH login
- a `.ssh/mobassh.key` file containing the private key to use for SSH login

# Usage

```cmd
MobaSSH.exe [IPs ...] [Command]
```

## Example

Start three SSH Sessions to `1.2.3.4`, `5.6.7.8` and `9.10.11.12` and execute `ping 1.1.1.1` as initial command
```cmd
MobaSSH.exe 1.2.3.4 5.6.7.8 9.10.11.12 ping 1.1.1.1
```

or

Copy

```
1.2.3.4
5.6.7.8
9.10.11.12
```

to Clipboard and run

```cmd
MobaSSH.exe ping 1.1.1.1
```