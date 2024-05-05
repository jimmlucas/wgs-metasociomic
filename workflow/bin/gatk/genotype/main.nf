process GENOTYPE {
    tag "genotype process $sample_id"

    input:
    tuple val(sample_id), path(input_vcf), path(reference)

    output:
    tuple val(sample_id), path("${sample_id}.vcf.gz")

    script:
    """
    gatk GenotypeGVCFs \
    -R ${reference} \
    -V ${input_vcf} \
    -O ${sample_id}.vcf.gz
    """
}