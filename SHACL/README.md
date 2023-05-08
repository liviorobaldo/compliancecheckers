<p align="justify">
This folder contains the implementation of the use case as <a href="https://www.w3.org/TR/shacl-af/#SPARQLRule">SHACL SPARQLrules</a>. The norms of the use case have been implemented within the file <b>regulativerules.ttl</b>. The regulative rules are able to infer which actions of the state of affairs are prohibited, obligatory, or permitted.
</p>
<p align="justify">
On the other hand, the file <b>compliancerules.ttl</b> contains further SHACL SPARQLrules for checking compliance of the prohibitions and obligations derived through <b>regulativerules.ttl</b>. The file <b>compliancerules.ttl</b> derives a violation for either all prohibitions that took place in the state of affairs and were not compensated <i>or</i> for all obligations that did not take place in the state of affairs and were not compensated.
</p>

<p align="justify">
The state of affairs is described in one of the synthetic datasets (ABox) created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator available on this GitHub</a>. Each ABox contains individuals populating the ontologies in <b>licenceusecaseTBox.owl</b> and <b>riolOntology.owl</b>.
</p>

<p align="justify">The file <b>DetectViolationsOnCorpus.java</b> executes the SHACL rules on all ABox(es) it finds in the folder CORPUS created by the dataset generator. To compile and execute them, you need to install the <a href="https://www.oracle.com/java">Java Software Developer Kit (SDK)</a>. The files in this repository were developed and tested using Java version 11. The subfolder <b>lib</b> contains all Java libraries needed for the execution, specifically <b>shacl-1.3.2.jar</b>, the <a href="https://www.topquadrant.com/the-topbraid-evn-ontology-editor/">TopBraid</a> library to execute SHACL shapes and rules available <a href="https://repo1.maven.org/maven2/org/topbraid/shacl/1.3.2/">at this link</a>.
 
<p align="justify">
Once Java is installed, to compile the file on Windows write the following on a shell:
</p>

<p align="center">
<i>javac -cp .;./lib/* DetectViolationsOnCorpus.java</i>
</p>

<p align="justify">
After the file is compiled (<b>DetectViolationsOnCorpus.class</b> has been generated) write:
</p>

<p align="center">
<i>java -cp .;./lib/* -Dfile.encoding=utf-8 DetectViolationsOnCorpus "licenceusecaseTBox.owl" "riolOntology.owl" "regulativerules.ttl" "compliancerules.ttl" "CORPUS/SHACL"</i>
</p>

<p align="justify">
to run the file on the CORPUS folder created by the dataset generator. Similar scripts can be used to compile and run the files on other operating systems.
</p>

<p align="justify">
You need to copy the folder CORPUS in the same folder where you run <b>DetectViolationsOnCorpus.class</b>. If you want to place it somewhere else, you have just to change the last parameter above: write the full path of the CORPUS/SHACL folder in place of "CORPUS/SHACL". The execution of the file <b>DetectViolationsOnCorpus.java</b> will create a new file <b>evaluationSHACL.txt</b> within the CORPUS folder.
</p>
