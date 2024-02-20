process PRUNING-MAPPING {
    tag "Filter-HumanNoise"

    input:
    path 

    output:
    path  

    script:

    """
    bowtie2 -build
    bowtie2 
    """


}