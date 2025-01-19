# Get-Uptime PowerShell Function

A PowerShell function to retrieve uptime information for one or more Windows computers.

## Table of Contents

- [Synopsis](#synopsis)
- [Syntax](#syntax)
- [Description](#description)
- [Parameters](#parameters)
- [Examples](#examples)
- [Notes](#notes)
- [Troubleshooting](#troubleshooting)

## Synopsis

The `Get-Uptime` function allows you to query the boot time and current uptime of specified Windows computers. It supports remote execution, credential passing, and various output formats.

## Syntax

``` Get-Uptime [-ComputerName <String[]>] [-Credential <PSCredential>] [-OutputFormat <String>] [-LogPath <String>] ```

## Description

The `Get-Uptime` function uses Windows Management Instrumentation (WMI) to retrieve operating system information from target computers. It calculates the current uptime based on the last boot time and provides options for formatting the output.

## Parameters

- **ComputerName**: Specifies the target computers. Default is the local computer.
- **Credential**: Specifies alternate credentials for connecting to remote computers.
- **OutputFormat**: Specifies the output format. Valid options are "Object" (default), "CSV", or "HTML".
- **LogPath**: Specifies the path for the log file. Default is "$env:TEMP\Get-Uptime.log".

## Examples

1. Get uptime for the local computer:

``` Get-Uptime ```

2. Get uptime for multiple remote computers:

``` Get-Uptime -ComputerName "Server1", "Server2", "Server3" ```

3. Get uptime and export results to CSV:

``` Get-Uptime -ComputerName "Server1", "Server2" -OutputFormat CSV ```

4. Get uptime using alternate credentials:

``` $cred = Get-Credential | Get-Uptime -ComputerName "RemoteServer" -Credential $cred ```

## Notes

- Ensure you have the necessary permissions to query WMI on target computers.
- The function uses PowerShell's parallel execution feature for improved performance when querying multiple computers.
- Error handling is implemented to provide informative messages for troubleshooting.

## Troubleshooting

If you encounter issues:

1. Check network connectivity to target computers.
2. Verify that the Remote Registry service is running on target computers.
3. Ensure you have the necessary permissions.
4. Review the log file specified by the -LogPath parameter for detailed error messages.

Remember, as the old IT adage goes: "Have you tried turning it off and on again?" But with this script, at least you'll know exactly how long it's been since someone did!
