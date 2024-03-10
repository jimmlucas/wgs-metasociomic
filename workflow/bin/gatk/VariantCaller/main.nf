process VARIANTCALLER {
    tag "Haplotype ${sample_id}"
    
    publishDir "${params.outdir}/3-finalVCF", mode: 'copy',
    saveAs: { filename ->
        filename.endsWith(".gz") ? "VCF/$filename" : null
    }

    container "$params.gatk4.docker"

    input:
    tuple val (sample_id), path (bam)
    path (reference)

    output:
    tuple val (sample_id), path("${sample_id}.g.vcf.gz")

    script:
    """
    samtools faidx ${reference}
    gatk CreateSequenceDictionary -R ${reference} -O ${reference.toString().replace('.fa', '.dict')}
    
    gatk --java-options "-Xmx4g" HaplotypeCaller \
    -R ${reference} \
    -I ${bam} \
    -O ${sample_id}.g.vcf.gz \
    -ERC GVCF
    """
}