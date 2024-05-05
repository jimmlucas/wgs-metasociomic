process GENOTYPE {
    tag "genotype ${sample_id}"
    
    publishDir "${params.outdir}", mode: 'copy', saveAs: { filename ->
        if (filename.endsWith(".vcf.gz")) "3-finalVCF/VCF/$filename"
        else null
    }
    
    container "$params.gatk4.docker"

    input:
    tuple val(sample_id), path(vcf)
    path(reference)

    output:
    path("${sample_id}.final.vcf.gz")

    script:
    """
    if [ ! -f ${reference}.fai ]; then
        samtools faidx ${reference}
    fi
    if [ ! -f ${reference.toString().replace('.fa', '.dict')} ]; then
        gatk CreateSequenceDictionary -R ${reference} -O ${reference.toString().replace('.fa', '.dict')}
    fi
    if [ ! -f ${vcf}.tbi ]; then
        tabix -p vcf ${vcf}
    fi
    gatk GenotypeGVCFs \
    -R ${reference} \
    -V ${vcf} \
    -O ${sample_id}.final.vcf.gz
    """
}