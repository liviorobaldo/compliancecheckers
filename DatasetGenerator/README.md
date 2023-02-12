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
There are four parameters to configure the dataset generator. 
</p>

<p align="justify">
"numbersOfUseCases" is used to duplicate the norms in the use case. For instance, if its value is "{1, 10, 20}", the generator creates three datasets: one in which the if-then rules in the use case are duplicated a single time, one in which they are duplicated 10 times, and one in which they are duplicated 20 times. As you can see in the Java code, each dataset is stored within a subfolder of "INDEXED_RULES", for every reasoner.
</p>


<p align="justify">
"minSize", "maxSize", and "stepSize" are used to generate the sets of states of affairs, for every dataset of duplicated rules. For instance, if minSize=10, maxSize=50, and stepSize=10, the generator creates datasets of 10, 20, 30, 40, and 50 states of affairs for each dataset of duplicated if-then rules created via "numbersOfUseCases", i.e., for every subfolder of "INDEXED_RULES" of every reasoner.
</p>
