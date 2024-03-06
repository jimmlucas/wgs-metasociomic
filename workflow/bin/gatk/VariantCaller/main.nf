process VARIANTCALLER {
    tag "Haplotype ${sample_id}"

    container "$docker pull broadinstitute/gatk"

    input:
    tuple val (sample_id), path (bam)
    path (reference)

    output:
    tuple val (sample_id), path ("${sample_id}.table"), path("${sample_id}.g.vcf.gz")

    script:
    def avail_mem = 3072

    """
    gatk --java-options "-Xmx${avail_mem}" BaseRecalibrator \
    -I ${bam} \
    -R ${reference} \
    -O ${sample_id}.table

    gatk --java-options "-Xmx10G" HaplotypeCaller\
    -R ${reference} \
    -I ${bam} \
    -O ${sample_id}.g.vcf.gz \
    -ERC GVCF

    """


}