
# Options for process:execute 
The eXistdb process module enables admin users to execute system command on the maschine where eXist is running. The process:execute command receives two parameters, the command to execute and optional a list of options. These options are

* workingDir
* enviroment
* stdin


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
