/*
DSL2 channels
*/
nextflow.enable.dsl=2

checkInputParams()

reference         = file("${params.reference}")
trimadapter       = file("${params.trimmomatic_ADAPTER}")

log.info """\

WGS METASOCIOMIC - N F   P I P E L I N E
==============================================
Configuration environemnt:
    Out directory:             $params.outdir
    Fastq directory:           $params.input
    Reference directory:       $params.reference
"""
    .stripIndent()


//Call all the sub-work

include { FASTQC_QUALITY as FASTQC_QUALITY_ORIGINAL }         from './workflow/bin/fastqc/main'
include { BUILD_INDEX as BUILDE_HUMAN_INDEX}                  from './workflow/bin/trimming/bowtie2/index/main'
include { PRUNING-MAPPING as PRUNING_HUMAN_NOISE}             from './workflow/bin/bowtie2/mapping/main'
//include { PRUNING_TRIMMING }                                from './workflow/bin/trimming/trimmomatic/main'
//include { FASTQC_QUALITY as FASTQC_QUALITY_FINAL }          from './workflow/bin/fastqc/main' 
//include { BUILD_INDEX }                                     from './workflow/bin/bwa/index/main'
//inlcude { MAPPING }
workflow {
//First Quality-control
    read_ch = Channel.fromFilePairs(params.input, size: 2 )
    fastqc_ch_original= FASTQC_QUALITY_ORIGINAL(read_ch.map{it -> it[1]})
//Workflow-started
//Build a INDEX Human-reference "GRCh37/hg19"
    reference_ch = Channel.fromSet(params.reference)
    human_index = PRUNING_HUMAN_NOISE(reference_ch)
    
//trim-reads
//    trimmed_read_ch = TRIMREADS(read_ch, params.trimmomatic_ADAPTER)
//Final Quality control after trimming
    FASTQC_QUALITY_FINAL(trimmed_read_ch.map { it -> it[1] })
// INDEX reference genome
//    bwaIndex(params.reference)
//Mapping Process- include samtools sorted and INDEX
    

}


////////////////////////////////////////////////////////////////////////////////
// FUNCTIONS                                                                  //
////////////////////////////////////////////////////////////////////////////////


def checkInputParams() {
    // Check required parameters and display error messages
    boolean fatal_error = false
    if ( ! params.input) {
        log.warn("You need to provide a fastqDir (--fastqDir) or a bamDir (--bamDir)")
        fatal_error = true
    }
    if ( ! params.reference ) {
        log.warn("You need to provide a genome reference (--reference)")
        fatal_error = true
    }
}
