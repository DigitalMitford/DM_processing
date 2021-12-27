
# Options for process:execute 
The eXistdb process module enables admin users to execute system command on the maschine where eXist is running. The process:execute command receives two parameters, the command to execute and optional a list of options. These options are

* workingDir
* enviroment
* stdin

If you want to print environment variables or pass wildcard character to scripts it is necessary to call *sh*, *bash* or *zsh* with the -c option and provide the command as a single third parameter.


## Working Directory

The workingDir parameter is used to specify the directory in which the command is executed. In this sample the workingDir is 'etc', if you don't specify a directory the eXistdb home directory is used as workingDir parameter. 

```xquery
let $options := \<option>
                    \<workingDir>/etc\</workingDir>
                \</option>
return
	process:execute(("ls","-l"),$options)
```
### Result

Lists the files in the directory '/etc' in long format (-l)


## Environment Variables

```xquery
let $options := \<option>
			        \<environment>
			            \<env name="DATA" value="/path/to/data"/>
		            \</environment>
				\</option>
return 
	process:execute(("sh", "-c", "echo $DATA"), $options)
```


### Result

Echoes the value of the environment variable $DATA which is '/path/to/data'

## Wildcards / globbing

In order to pass wildcard characters down to the shell-script this must also be done using `sh -c`.

Note: **bash**, **zsh** and **sh** do have the `-c` option.

```xquery
let $options := \<option>
                    \<workingDir>/tmp\</workingDir>
                \</option>

process:execute(("sh", "-c", "ls *.xml"), )
```

### Result

Lists all files with xml as their file extension.

**NOTE:** `process:execute(("ls", "*.xml"), $options)` returns an error.

## stdin
The command executed via process:execute reads the value(s) given as stdin argument(s)

```xquery
let $options := \<option>
				    \<stdin>
				        \<line>One</line>
				        \<line>Two</line>
				    \</stdin>
				\</option>

return 
	process:execute(("wc", "-l"), $options)   
```

### Result

The Unix command 'wc -l' prints the line count of the given argument (here <stdin>). The result is '2'.
