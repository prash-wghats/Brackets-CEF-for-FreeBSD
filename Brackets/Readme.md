# Brackets for FreeBSD
Brackets => 1.11  
CEF => 2704  
Chromium =>  51.0.2704.103

## <ins>Build Instruction:</ins>
If manually building all the components (CEF and node) run `sh build_node.sh` to build node.
```
sh build_brackets.sh
```

Once the build is complete, the Brackets files will be placed in
`bracket-shell/installer/linux/debian/package-root/opt/brackets/*`. 
The build directory is `bracket-shell/out/Release/*`

If the Localization is not set, BracketIO doesnt work properly.
example:

`~/.login_conf`
```
	me:\
        :charset=UTF-8:\
        :lang=en_US.UTF-8:\
        :setenv=LC_COLLATE=C:
```
For Live Preview, add  
```
	"livedev.multibrowser": true, 
```
to the Brackets preference file,   
`Debug -> Open Preference File`