process BUILD_INDEX {
    tag "Index-ReferenceGenome ${reference_id.name}"

    // Asumiendo que `params.reference` es el directorio donde se guardarán los índices
    publishDir "${params.reference}", mode: 'copy', saveAs: { filename ->
        if (filename.contains("index_personal_genome")) "personal/$filename"
        else if (filename.contains("index_sp_genome")) "Specie/$filename"
        else filename
    }

    input:
    path reference_id

    output:
    path "index_*_genome*", emit: index_data

    script:
    def index_prefix = ""

    if (reference_id == file(params.sp_ref)) {
        index_prefix = "index_sp_genome"
    } else {
        index_prefix = "index_personal_genome"
    }

    // Bowtie2

    """
    bowtie2-build ${reference_id} $index_prefix
    """
}