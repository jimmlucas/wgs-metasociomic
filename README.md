# WGS-METASOCIOMIC

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![license-shield]][license-url]

Nextflow- Metasociomic analysing bacterial social interactions in metagenomes of longitudinally collected samples of human microbiomes.

The project aims to identify and analyze siderophore operons in metagenomic data, using the data from [Andersen et al. 2015](https://www.pnas.org/doi/full/10.1073/pnas.1508324112). For this purpose, an automated pipeline will be built with the possibility of customization in certain parameters : Quality analisis, mapping and variant calls on bacterial metagenomes. The pipeline take input: fastqs, followed by hard filtering and outputs: html, bams, and gvcfs for joint genotyping.

The following pipeline was constructed using Nextflow and Docker to better track the steps and provide an easy way to generate a final document.


## Requirements:
The pipeline requires NextFlow and Docker on the target system. These are ofthen pre-intsalled on HPC systems.

Nextflow - if you do not have install Nextflow, use the 

Docker:

## Process:

The recommended way is to clone it from github:

```
git clone https://github.com/jimmlucas/wgs-metasociomic.git
cd wgs-metasociomic
```
also reommended that you pre-pull the Docker imagen required by the workflow, there is a script "Dockerfile" in the directory. Remind run the following comand in the root:

```
docker pull ghcr.io/jimmlucas/wgs:short_reads
```

or 

runing the pipeline with the following command:

'''
nextflow run run.nf -with-docker jimmlucas/dvt:wgs
'''
## Preparation of inputs

***Download***

Sometimes we forget how to download masive reads from a DB. I am here to save your time and have provided a script for automatic-downloading. However, if you prefer to use your own date or you already have the reads downloaded, ignore this step and proceed to the next one.

Run the script in the root using:

```
bash ./workflow/bin/download_reads.sh 
```

Remmeber that if you want to use the automatic-downloading, you need to have the acceslist already prepare it and provide the full path of the file:

![image desc](../../Desktop/capturas/dowanloand.png)





## Reference:

[S. Andreu-Sanchez, L. Chen, D. Wang, H. Augustijn, A. Zhernakova, J. Fu - "A Benchmark of Genetic Variant Calling Pipelines Using Metagenomic Short-Read Sequencing", 2021](https://www.frontiersin.org/journals/genetics/articles/10.3389/fgene.2021.648229/full)

[S. Andersen, J.Schluter "A metagenomics approach to investigate microbiome sociobiology", 2021](https://www.pnas.org/doi/full/10.1073/pnas.2100934118)

[S. Andersen, R. Marvig, S. Molin, A. Griffin - "Long-term social dynamics drive loss of function in pathogenic bacteria",2015](https://www.pnas.org/doi/full/10.1073/pnas.1508324112)

[S. Brush -"Read trimming has minimal effect on bacterial SNP-calling accuracy"](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC8116680/#R2)



[contributors-shield]: https://img.shields.io/github/contributors/jimmlucas/wgs-metasociomic.svg?style=for-the-badge

[contributors-url]: https://github.com/jimmlucas/wgs-metasociomic/graphs/contributors

[forks-shield]: https://img.shields.io/github/forks/jimmlucas/wgs-metasociomic.svg?style=for-the-badge
[forks-url]: https://github.com/jimmlucas/wgs-metasociomic/branches

[stars-shield]: https://img.shields.io/github/stars/jimmlucas/wgs-metasociomic.svg?style=for-the-badge
[stars-url]: https://github.com/jimmlucas/wgs-metasociomic/stargazers

[issues-shield]: https://img.shields.io/github/issues/jimmlucas/wgs-metasociomic.svg?style=for-the-badge
[issues-url]: https://github.com/jimmlucas/wgs-metasociomic/issues

[license-shield]: https://img.shields.io/github/license/jimmlucas/wgs-metasociomic.svg?style=for-the-badge
[license-url]: https://github.com/jimmlucas/wgs-metasociomic/blob/master/LICENSE.txt
