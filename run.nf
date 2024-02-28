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

//include { FASTQC_QUALITY as FASTQC_QUALITY_ORIGINAL }     from './workflow/bin/fastqc/main'
//include { BUILD_INDEX as HUMAN_GENOME_INDEX           }     from './workflow/bin/trimming/bowtie2/index/main'
include { PRUNING_TRIMMING                                   }     from './workflow/bin/trimming/trimmomatic/main'
//include { PRUNING-MAPPING as PRUNING_HUMAN_NOISE      }     from './workflow/bin/bowtie2/mapping/main'
//include { PRUNING-MAPPING as PERSONAL_GENOME_MAPPING  }     from './workflow/bin/bowtie2/mapping/main'
//include { FASTQC_QUALITY as FASTQC_QUALITY_FINAL    }     from './workflow/bin/fastqc/main'
//include { BUILD_INDEX as PERSONAL_GENOME_INDEX        }     from './workflow/bin/trimming/bowtie2/index/main'
//inlcude { MARK_DUPLICATE                                }     from './workflow/bin/gatk/picard/main'
//include { VARIANT_CALLER                               }     from './workflow/bin/gatk/VariantCaller/main'
//include { JOIN_VCF}

workflow {
//1st Step
//First Quality-control
    read_ch = Channel.fromFilePairs(params.input, size: 2 )
//    fastqc_ch_original= FASTQC_QUALITY_ORIGINAL(read_ch.map{it -> it[1]})
//2nd Step - data proccesing (Pruning process)
//Build an INDEX - Human-reference "GRCh37/hg19"
    reference_ch = Channel.fromPath( [ "$params.human_ref" ] )
//    human_index_ch  = HUMAN_GENOME_INDEX (reference_ch)
// Build an INDEX - personal reference genome
    personal_ref_ch = Channel.fromPath( [ "$params.personal_ref" ] )
//    personal_index_ch  = PERSONAL_GENOME_INDEX (personal_ref_ch)
//Pruning (Bowtie2+ Trimming) the process use the ref. Human genoma
    //Trimming-Reads - Cleaning paired reads and trimming adapters
    trimmed_read_ch = PRUNING_TRIMMING(read_ch, params.trimmomatic_ADAPTER)
    //Bowti2- Human ref. genome filter
//    human_pruning_ch = PRUNING_HUMAN_NOISE (trimmed_read_ch, human_index_ch)
//3rd Quality Control
//Final Quality control after trimming
//    FASTQC_QUALITY_FINAL(trimmed_read_ch.map { it -> it[1] })
//4th Mapping process
//Mapping Process - Mapping used personal ref. genome, also include samtools sorted
//    personal_mapping_ch = PERSONAL_GENOME_MAPPING (human_pruning_ch, personal_index_ch)
//MarkDuplicate
//    duplicate_ch = MARK_DUPLICATE (personal_mapping_ch)
//5th Variant Caller
//    gatk_ch = VARIANT_CALLER (duplicate_ch)
//6th Join VCF

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
