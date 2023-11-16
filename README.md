# dtbook-to-odt

A DTBook to ODT converter for the [DAISY Pipeline 2][]

## Build
Use Java11 as compilation fails with Java18 with a java.lang.IllegalAccessError[^1]

```sh
mvn clean package
```

## Authors
- [Bert Frees][] 

## License

Copyright 2013 [Swiss Library for the Blind, Visually Impaired and Print Disabled][sbs]

Licensed under [GNU Lesser General Public License][] as published by
the Free Software Foundation, either version 3 of the License, or (at
your option) any later version.

[DAISY Pipeline 2]: https://github.com/daisy-consortium/pipeline-assembly/releases
[Bert Frees]: https://github.com/bertfrees
[sbs]: http://www.sbs.ch/
[GNU Lesser General Public License]: http://www.gnu.org/licenses/lgpl.html

## Footnotes

[^1]: org.codehaus.plexus.compiler.CompilerException: java.lang.IllegalAccessError: class org.daisy.pipeline.build.annotations.DsToSpiProcessor (in unnamed module @0x339cde4b) cannot access class com.sun.tools.javac.code.Type$ClassType (in module jdk.compiler) because module jdk.compiler does not export com.sun.tools.javac.code to unnamed module @0x339cde4b
	at org.codehaus.plexus.compiler.javac.JavaxToolsCompiler.compileInProcess(JavaxToolsCompiler.java:172)
