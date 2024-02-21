process PRUNING_TRIMMING {
    tag "trim ${pair_id}"

    publishDir "${params.outdir}/out/2-pruning",
     saveAs: {filename ->
            if (filename.indexOf("_paired.fq.gz") > 0) "trimmed_pairs/$filename"
            else if (filename.indexOf("_unpaired.fq.gz") > 0) "unpaired/$filename"
            else filename
    }
    
    input:
    tuple val(pair_id), path (reads)
    path trimadapter

    output:
    tuple val(pair_id), path("trimmed_${pair_id}_{1,2}_paired.fq.gz"), 
    path("trimmed_${pair_id}_{1,2}_unpaired.fq.gz")

    script:
    """
    trimmomatic PE ${reads[0]} ${reads[1]} \
    "trimmed_${pair_id}_1_paired.fq.gz" "trimmed_${pair_id}_1_unpaired.fq.gz" "trimmed_${pair_id}_2_paired.fq.gz" "trimmed_${pair_id}_2_unpaired.fq.gz" \
    ILLUMINACLIP:$trimadapter:2:30:10 LEADING:20 TRAILING:20 MINLEN:50 SLIDINGWINDOW:4:20 -threads ${params.max_threads}
    """
}