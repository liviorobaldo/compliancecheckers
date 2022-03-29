<p align="justify">
This folder contains the implementation of the use case as <a href="https://link.springer.com/chapter/10.1007/978-3-642-25655-4_14">PROLEG rules</a>. The use case has been implemented within the file <b>regulative+compliance_rules.pl</b>. This file contains both the regulative rules, able to infer which actions of the state of affairs are prohibited, obligatory, or permitted, and the rules for checking compliance of the derived prohibitions and obligations.
</p>

<p align="justify">The file <b>regulative+compliance_rules.pl</b> derives a violation for either all prohibitions that took place in the state of affairs and were not compensated <i>and</i> for all obligations that did not take place in the state of affairs and were not compensated.</p>

<p align="justify">
The state of affairs is described in one of the synthetic datasets (ABox) created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator available on this GitHub</a>. Each ABox is a collection of facts describing the states of affairs encoded in PROLEG's input format. Furthermore, since PROLEG is query-based, each ABox has been enriched with all queries that allow to infer a violation from the input facts. The queries must be invoked via a special run file that, on Windows, can be automatically created through the file <b>createProlegRunFile.java</b>. To compile and run the file, open a shell and use the following instructions:
</p>

<p align="center">
<i>javac createProlegRunFile.java</i><br>
  <i>java createProlegRunFile</i>
</p>

<p align="justify">
  Similar run files can be created on other operating systems by slightly modifying the file <b>createProlegRunFile.java</b>. 
</p>

<p align="justify">
  In order to execute PROLEG, you need to install a Prolog environment such as <a href="https://www.swi-prolog.org">SWI Prolog</a>, the one we used to execute the rules in 
  <b>regulative+compliance_rules.pl</b> on the created syntethic datasets. PROLEG is actually the Prolog library <b>prolegEng2.pl</b> that must be loaded before executing 
  the rules. Each ABox created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator</a> starts with the 
  following instruction, which loads the PROLEG library and the rules from the use case:
</p>

<p align="center">
<i>:- [ "./prolegEng2.pl", "./regulative+compliance_rules.pl" ].</i>
</p>

<p align="justify">
The execution of the run file will output the evaluation of each ABox in the CORPUS folder within the file <b>evaluationPROLEG.txt</b> together with the plaintiff-defendant explanations built by the PROLEG reasoner.
</p>
