<p align="justify">The file <b>DatasetGenerator.java</b> populates the folder <b>CORPUS</b>, given as parameter, with random ABox(es) of different size that are automatically generated. To compile and execute it, you need to install the <a href="https://www.oracle.com/java">Java Software Developer Kit (SDK)</a>. The Java files in this repository were developed and tested using Java version 11. The subfolder <b>lib</b> contains all Java libraries needed for the execution.
</p>
<p align="justify">
Once Java is installed, to compile the file on Windows write the following on a shell:
</p>

<p align="center">
<i>javac -cp .;./lib/* DatasetGenerator.java</i>
</p>

<p align="justify">
After the file is compiled (<b>DatasetGenerator.class</b> has been generated) write
</p>

<p align="center">
<i>java -cp .;./lib/* -Dfile.encoding=utf-8 DatasetGenerator "./CORPUS"</i>
</p>

<p align="justify">
to generate the datasets within the CORPUS folder. Similar scripts can be used to compile and run the file on other operating systems.
</p>

<p align="justify">
PS. the subfolder "./CORPUS/SPINdle" must contain the file "SPINdle_regulative+compliance_rules.dfl". This contains the non-indexed SPINdle rules that the dataset generator will ground.
</p>
