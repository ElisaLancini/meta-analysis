[![ResearchGate][researchgate-shield]][researchgate-url]
[![LinkedIn][linkedin-shield]][linkedin-url]
[![Twitter][Twitter-shield]][Twitter-url]




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


<!-- CONTRIBUTING -->
## Contributing

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
