<p align="justify">
This folder contains the implementation of the use case as <a href="https://link.springer.com/chapter/10.1007/978-3-642-25655-4_14">PROLEG rules</a>. The use case has been implemented within the file <b>regulative+compliance_rules.pl</b>. This file contains both the regulative rules, able to infer which actions of the state of affairs are prohibited, obligatory, or permitted, and the rules for checking compliance of the derived prohibitions and obligations.
</p>

<p align="justify">The file <b>regulative+compliance_rules.pl</b> derives a violation for either all prohibitions that took place in the state of affairs and were not compensated <i>and</i> for all obligations that did not take place in the state of affairs and were not compensated.</p>

<p align="justify">
The state of affairs is described in one of the synthetic datasets (ABox) created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator available on this GitHub</a>. Each ABox is a collection of facts describing the state of affairs encoded in PROLEG's input format. Furthermore, since PROLEG is query-based each ABox has been enriched with all queries that allow to infer a violation from the input facts. The queries must be invoked via a special run file that must be automatically created through the file <b>createProlegRunFile.java</b>. To compile and run the file, open a shell and use the following instructions:
</p>

<p align="center">
<i>javac createProlegRunFile.java</i><br>
  <i>java createProlegRunFile</i>
</p>

<p align="justify">
We invite you to visit <a href="https://apice.unibo.it/xwiki/bin/view/Arg2p/WebHome">the official website of Arg2P</a>, from which you may download the sources of the reasoner and find detailed instructions for using and configuring it. The files available on this GitHub have been prepared only to quickly run the use case considered here. To execute the Arg2P rules modelling the use case, on Windows you just write the following instruction on a shell:
</p>

<p align="center">
<i>gradlew run > ./CORPUS/evaluationArg2P.txt</i>
</p>

<p align="justify">
The execution of the above instruction will output the evaluation of each ABox in the CORPUS folder within the file <b>evaluationArg2P.txt</b>. If this file does not yet exist, it will be created. To execute Arg2P on other operating systems and/or with other use cases please visit <a href="https://apice.unibo.it/xwiki/bin/view/Arg2p/WebHome">the official website of Arg2P</a> or contact the Arg2P developers.
</p>
