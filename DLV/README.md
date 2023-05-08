<p align="justify">
This folder contains the implementation of the use case as <a href="https://dl.acm.org/doi/10.1145/1149114.1149117">DLV system rules</a>. The use case has been implemented within the file <b>regulative+compliance_rules.dlv</b>. This file contains both the regulative rules, able to infer which actions of the state of affairs are prohibited, obligatory, or permitted, and the rules for checking compliance of the derived prohibitions and obligations. DLV is just standard ASP augmented with inheritance networks to implement overridding of the rules.
</p>

<p align="justify">The file <b>regulative+compliance_rules.dlv</b> derives a violation for either all prohibitions that took place in the state of affairs and were not compensated <i>and</i> for all obligations that did not take place in the state of affairs and were not compensated.</p>

<p align="justify">
The state of affairs is described in one of the synthetic datasets (ABox) created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator available on this GitHub</a>. Each ABox is a collection of ASP facts describing the state of affairs.
</p>

<p align="justify">
The DLV reasoner is available in the <b>executables</b> subfolder. Although the reasoner could be directly used via consolle, we invoke it through the file <b>dlv.py</b>. The latter takes the ABox files in the corpus one by one and process them through the reasoner together with the rules.
</p>

<p align="justify">
To run the reasoner, you just run the instructions in the file <b>run.bat</b>. These will first execute the local Java file <b>createDLVRunFile.java</b> that will generate indexed copies of the file <b>regulative+compliance_rules.dlv</b> within the subfolder <b>INDEXED_RULES</b> as well as a file <b>run2.bat</b> that will execute the indexed rules one by one.
</p>