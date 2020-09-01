<style>
.data-format-table {
	background-color: #263238;
	width: 90%;
    border-bottom-right-radius: 10px;
    border-bottom-left-radius: 10px;
    border-top-right-radius: 10px;
    border-top-left-radius: 10px;
}
.data-format-table-line{
	border-bottom: 1px solid #ddd;
}
.data-format-table-column-names{
	text-align: center;
	color: #66cdaa;
}
.data-format-table-text{
	text-align: center;
	color: #878787;
}
.stepbox{
    border-bottom-right-radius: 10px;
    border-bottom-left-radius: 10px;
    border-top-right-radius: 10px;
    border-top-left-radius: 10px;
	border: 1px solid white;
	display: inline-block;
    width: 33%;
 	text-align: center;
	background-color: #263238;
}
.steps{
	font-size: x-large;
	font-weight: bold;
	color: #66cdaa;
}
.step-text{
	font-size: large;
	color: #878787;
}
</style>

## <b>predPCR</b>

predPCR is a web server for using the machine learning model to predict the decision on PCR curves using the [PCRedux](https://cran.r-project.org/package=PCRedux) package.
The whole code of an application and a model is open source and available on [GitHub](https://github.com/PrzeChoj/predPCR).

### Data format

The expected input data is <b>.csv</b> spreadsheet in the [qpcR](https://cran.r-project.org/package=qpcR) format. The first column represents the cycle number The following commands represent particular runs.

<table class="data-format-table">
  <thead>
    <tr class="data-format-table-line">
      <td class="data-format-table-column-names"><b>Cycle</b></td>
      <td class="data-format-table-column-names"><b>Run1</b></td> 
      <td class="data-format-table-column-names"><b>Run2</b></td> 
      <td class="data-format-table-column-names">...</td> 
    </tr>
  </thead>
  <tr class="data-format-table-line">
    <td class="data-format-table-text">1</td>
    <td class="data-format-table-text">17.22</td>
    <td class="data-format-table-text">15.52</td>
    <td class="data-format-table-text">...</td>
  </tr>
  <tr class="data-format-table-line">
    <td class="data-format-table-text">2</td>
    <td class="data-format-table-text">17.31</td>
    <td class="data-format-table-text">17.17</td>
    <td class="data-format-table-text">...</td>
  </tr>
  <tr class="data-format-table-line">
    <td class="data-format-table-text">3</td>
    <td class="data-format-table-text">16.99</td>
    <td class="data-format-table-text">17.01</td>
    <td class="data-format-table-text">...</td>
  </tr>
  <tr>
    <td class="data-format-table-text">...</td>
    <td class="data-format-table-text">...</td>
    <td class="data-format-table-text">...</td>
    <td class="data-format-table-text">...</td>
  </tr>
</table>
<br>

Or the Real-time PCR Data Markup Language <b>.rdml</b> (universal data standard for exchanging quantitative PCR) file compataible with [RDML](https://cran.r-project.org/package=RDML) package.
You can generate your own <b>.rdml</b> files [here](http://shtest.evrogen.net/RDMLedit/).

### How to use predPCR?
<div class="stepbox">
<div class="steps">Step 1</div>
<div class="step-text">Load data file.</div>
</div>
<div class="stepbox">
<div class="steps">Step 2</div>
<div class="step-text">Make predictions.</div>
</div>
<div class="stepbox">
<div class="steps">Step 3</div>
<div class="step-text">Save predictions.</div>
</div>


### Authors

- [Stefan Rödiger](https://www.researchgate.net/profile/Stefan_Roediger) | Stefan.Roediger[at]b-tu.de
- [Michał Burdukiewicz](https://www.researchgate.net/profile/Michal_Burdukiewicz) | michalburdukiewicz[at]gmail.com
- [Przemysław Chojecki](https://github.com/PrzeChoj) | premysl.choj[at]gmail.com
- [Paulina Przybyłek](https://github.com/p-przybylek) | pp.paulinaprzybylek[at]gmail.com