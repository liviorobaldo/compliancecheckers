# Legal reasoners

<p align="justify">
This GitHub repository contains implementations of a selected use case of legal norms in different automatic reasoners.
</p>

<p align="justify">
The use case includes the following four articles:

<ul>
  <li><b>Article 1</b>. The Licensor grants the Licensee a licence to evaluate the Product.</li>
  <li><b>Article 2</b>. The Licensee must not publish the results of the evaluation of the Product without the approval of the Licensor. If the Licensee publishes results of the evaluation of the Product without approval from the Licensor, the material must be removed.</li>
  <li><b>Article 3</b>. The Licensee must not publish comments about the evaluation of the Product, unless the Licensee is permitted to publish the results of the evaluation.</li>
  <li><b>Article 4</b>. If the Licensee is commissioned to perform an independent evaluation of the Product, then the Licensee has the obligation to publish the evaluation results.</li>
</ul>
</p>

<p align="justify">
The norms in the use case has been implemented as:

<ul>
  <li><a href="https://www.w3.org/TR/shacl-af/#rules">Shapes Constraint Language (SHACL)</a> rules. Source code and instructions are available <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/SHACL">here</a>.</li>
  <li><a href="https://potassco.org/">Answer Set Programming (ASP)</a> rules via <a href="https://github.com/potassco/clingo/releases">Clingo v5.5.1</a> or <a href="https://www.dlvsystem.it/dlvsite/dlv/">DLV v2</a>. Source code and instructions are available <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/ASP">here</a>.</li>
  <li><a href="https://dl.acm.org/doi/10.1145/1149114.1149117">DLV system</a> rules. Source code and instructions are available <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DLV">here</a>.</li>
  <li><a href="https://link.springer.com/chapter/10.1007/978-3-642-25655-4_14">PROLEG</a> rules. Source code and instructions are available <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/PROLEG">here</a>.</li>
  <li><a href="https://apice.unibo.it/xwiki/bin/view/Arg2p/WebHome">Arg2P</a> rules. Source code and instructions are available <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/Arg2P">here</a>.</li>
  <li><a href="http://spindle.data61.csiro.au/">SPINdle</a> rules. Source code and instructions are available <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/SPINdle">here</a>.</li>
</ul>

</p>

<p align="justify">
The implementations can be tested on the synthetic (Abox) datasets created via the dataset generator <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">at this link</a>.
</p>
