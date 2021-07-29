[![ResearchGate][researchgate-shield]][researchgate-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
[![Twitter-shield]][Twitter-url]




<!-- PROJECT LOGO -->
<p align="left">
  <h4 align="center">This repository contains all the codes of the analyses reported in the manuscript:</h3>
</p>
<p align="center">
  <h2 align="center">CSF and PET biomarkers for noradrenergic dysfunction in neurodegenerative disease: a systematic review and meta-analysis</h3>
</p>
<p align="center">
  <h6 align="center">E. Lancini, F. Bartl, M. Rühling, L. Haag, NJ. Ashton, H. Zetterberg, E. Düzel, D. Haemmerer*, MJ. Betts*</h3>
</p>

<!-- TABLE OF CONTENTS -->
<details open="open">
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#methods">Methods</a></li>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#r-version">R version</a></li>
        <li><a href="#r-packages-installation">R packages installation</a></li>
      </ul>
    </li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#contact">Affiliations</a></li>
    <li><a href="#acknowledgements">Acknowledgements</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

The noradrenergic system shows pathological modifications in aging and neurodegenerative diseases. We summarized data of studies reporting CSF NA or MHPG levels and PET MeNER measures, in controls as well as PD and ADD patients. The effect sizes obtained from the comparison between PD/ADD and control groups were combined into a pooled effect size estimate.
DOI: XXXXXXXX

### Methods:

<p align="left">
  <h4 align="left"> - Effect sizes and Welch's test:</h3>
</p>
For every article, independent Welch’s t-test was conducted to assess mean differences between control and PD or ADD groups. Then, the standardized mean differences (SMD) were calculated with Hedge’s g correction for small samples (Lakens, 2013). 
<p align="left">
  <h4 align="left"> - Meta-analysis and forestplot:</h3>
</p>
Single studies effect sizes were combined with a random-effect mixed-model meta-analysis using the metagen function from R package meta (Viechtbauer, 2010).The estimation of the average true effect (μ) was calculated with a 95% confidence interval and the between-study-variance using the tau-squared estimator (τ2). To control for the small number of studies included per group, we applied the adjustment method proposed by Hartung-Knapp-Sidik-Jonkman (HKSJ)
The causes of the remaining statistical heterogeneity were investigated by (1) identifying statistical outliers and (2) potential influential cases. 

  * (1) if the upper bound of the 95% confidence interval of the effect size estimate was lower than the lower bound of the pooled effect confidence interval (i.e., extremely small effects) or if the lower bound of the 95% confidence interval of the effect size was higher than the upper bound of the pooled effect confidence interval. These extreme effect sizes were identified with the R function find.outliers. 
  * (2) studies that exert a very high influence on overall results, using the Leave-One-Out method and Graphic Display of Heterogeneity plots using R (R Core Team, 2017).

The pooled effect sizes were included in a forestplot. The studies were characterized on the basis of the analytical method used to evaluate the noradrenergic levels of CSF, coded through the different shapes of the data points, and severity, coded through the different colors of the data points

<p align="left">
  <h4 align="left"> - Meta-regression:</h3>
</p>
Meta-regressions were performed to assess the influence of hypothesized explanatory variables.
<p align="left">
  <h4 align="left"> - Foresplot and averaged mean differences with grouped data:</h3>
</p>
The articles that did not report a comparison in CSF measures between ADD or PD groups and a control group were not suitable for the effect size calculation and therefore not included in the meta-analysis. However, in order to assess absolute differences in CSF measures across studies and between groups (HC; ADD; PD), data from these studies were grouped together with data from the papers included in the meta-analysis in a forest plot of means and standard deviations. The arithmetical averaged mean was calculated for each group (HC; ADD; PD) and measure (MHPG; NA), and a value of 2 standard deviations from the arithmetical averaged mean was used to detect outlier data in every group. Studies identified as outliers were removed from subsequent analyses. An averaged mean and SD was calculated for each group (HC; ADD; PD) and measure (MHPG; NA). Differences in the averaged mean between groups were calculated using the Kruskal-Wallis test. This analysis was not conducted for PET studies as the groups (PD; HC) were composed of only two studies. For the data visualization plot, weighted averaged means of the groups were calculated using the sample size as weight.

### Built With

Part of the codes are adapted from [Harrer, M., Cuijpers, P., Furukawa, T.A., & Ebert, D.D. (2021). Doing Meta-Analysis with R: A Hands-On Guide](https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/)


<!-- GETTING STARTED -->
## Getting Started

Important: Once you have downloaded the scripts, you will need to adapt the paths to the folder where they are located on your PC.
The current scripts have been adapted to our data set and the type of analysis we were interested in, so there may be a better pipeline that fits your specific data. 
### R version

To get a local copy up and running install R software (version R i386 3.4.2) (R Core Team, 2017).

### R Packages installation

We used various R packages.

* readxl
* openxlsx
* writexl
* esc
* magrittr
* dplyr
* dmetar
* meta
* metafor
* grid
* forestplot
* checkmate

You can install them writing the following line in your R console

  ```sh
install.packages(c("readxl", "openxlsx", "writexl","esc","magrittr","dplyr","dmetar","meta","metafor","grid","forestplot","checkmate")).
  ```
  
<!-- CONTACT -->
## Contact

Elisa Lancini, MSc

* elisa.lancini@dzne.de
* [Twitter](https://twitter.com/e_lancini/)
* [ResearchGate](https://www.researchgate.net/profile/Elisa-Lancini?ev=hdr_xprf)

Project Link: [https://github.com/ElisaLancini/meta-analysis/](https://github.com/ElisaLancini/meta-analysis/)

<!-- CONTRIBUTING -->

A special thanks to the contributors who provided additional content in some codes:

  * [Calida Pereira](https://www.linkedin.com/in/calida-pereira/)
  * [Valentin Baumann](https://kkjp.med.ovgu.de/Team/Mitarbeiter/M_Sc_+Valentin+Baumann-p-438.html)

<!-- AFFILIATIONS -->
## Authors affiliations:

- Otto-von-Guericke-Universität Magdeburg 
- Institute for Cognitive Neurology and Dementia Research (IKND)
- Deutsches Zentrum für Neurodegenerative Erkrankungen (DZNE)
- AG Dr. Matthew Betts: Imaging subcortical systems in ageing and disease
- AG Dr. Dorothea Hämmerer: Developmental cognitive neuroscience across the lifespan and neuroimaging in dementia

<!-- ACKNOWLEDGEMENTS -->
## Acknowledgements
* [Harrer, M., Cuijpers, P., Furukawa, T.A., & Ebert, D.D. (2021). Doing Meta-Analysis with R: A Hands-On Guide](https://bookdown.org/MathiasHarrer/Doing_Meta_Analysis_in_R/)
* [Best-README_Template](https://github.com/othneildrew/Best-README-Template)
* [Img Shields](https://shields.io)



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[researchgate-shield]: https://img.shields.io/badge/-ResearchGate-black.svg?style=for-the-badge&logo=ResearchGate&colorB=555
[researchgate-url]: https://www.researchgate.net/profile/Elisa-Lancini?ev=hdr_xprf
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://www.linkedin.com/in/elisa-lancini/
[twitter-shield]: https://img.shields.io/badge/-Twitter-black.svg?style=for-the-badge&logo=Twitter&colorB=555
[twitter-url]: https://twitter.com/e_lancini
