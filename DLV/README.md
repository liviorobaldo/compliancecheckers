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
Therefore, to run the reasoner, you need to run the file <b>dlv2.py</b> with the proper parameters. For instance, if the folder CORPUS is located in the same folder of the chosen Python file, on Windows you just write the following instruction on a shell:
</p>

<p align="center">
<i>python .\dlv.py .\regulative+compliance_rules.dlv -f .\CORPUS\ASP -o .\CORPUS\evaluationDLV.txt</i>
</p>

<p align="justify">
The execution of the above instruction will write the evaluation of each ABox in the CORPUS folder within the file <b>evaluationDLV.txt</b>. If this file does not yet exist, it will be created. Similar scripts can be used to compile and run the files on other operating systems. 
</p>
