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
include { FASTQC_QUALITY as FASTQC_QUALITY_ORIGINAL }     from './workflow/bin/fastqc/main'
include { BUILD_INDEX as SPECIE_GENOME_INDEX          }     from './workflow/bin/trimming/bowtie2/index/main'
include { BUILD_INDEX as PERSONAL_GENOME_INDEX        }     from './workflow/bin/trimming/bowtie2/index/main'
include { PRUNING_TRIMMING                            }     from './workflow/bin/trimming/trimmomatic/main'
include { PERSONAL_GENOME_MAPPING                     }     from './workflow/bin/trimming/bowtie2/mapping/mapping_main'
include { SPECIE_GENOME_MAPPING                       }     from './workflow/bin/trimming/bowtie2/mapping/mapping_sp_main'
include { FASTQC_QUALITY as FASTQC_QUALITY_FINAL    }     from './workflow/bin/fastqc/main'
include { MARKDUPLICATE                               }     from './workflow/bin/gatk/picard/main'
include { ADDORREPLACE                                }     from './workflow/bin/gatk/picard/addorreplace'
include { VARIANTCALLER                               }     from './workflow/bin/gatk/VariantCaller/main'

workflow {

//1st Step
//First Quality-control
    read_ch = Channel.fromFilePairs(params.input, size: 2 )
    fastqc_ch_original= FASTQC_QUALITY_ORIGINAL(read_ch.map{it -> it[1]})

//2nd Step - data proccesing (Pruning process)
//Build an INDEX - Specie reference genome
    specie_ref_ch = Channel.fromPath (["$params.sp_ref"])
    specie_index_ch = SPECIE_GENOME_INDEX (specie_ref_ch)
// Build an INDEX - personal reference genome
    personal_ref_ch = Channel.fromPath( [ "$params.personal_ref" ] )
    personal_index_ch  = PERSONAL_GENOME_INDEX (personal_ref_ch)
//Pruning (Bowtie2+ Trimming) the process use the ref. Human genoma
    //Trimming-Reads - Cleaning paired reads and trimming adapters
    trimmed_read_ch = PRUNING_TRIMMING(read_ch, params.trimmomatic_ADAPTER)

//3rd Quality Control
//Final Quality control after trimming
    FASTQC_QUALITY_FINAL(trimmed_read_ch.map { it -> it[1] })

//4th Mapping process
//Mapping Process 1st step (Specie) - Mapping used Specie ref. genome, also include samtools sorted
    specie_mapping_ch   = SPECIE_GENOME_MAPPING (trimmed_read_ch, params.index_genome_specie)
//Mapping Process - 2do Step (personal) - Mapping used personal ref. genome, also include sammtools sorted
    specie_mapping_tuple_ch = specie_mapping_ch.map { tupla ->
    def sample_id = tupla[0]
    def specie_path = tupla[1]
    return tuple(sample_id, specie_path)
    }
    specie_mapping_tuple_ch.view()
    personal_mapping_ch = PERSONAL_GENOME_MAPPING (specie_mapping_tuple_ch, params.index_genome_personal)

//MarkDuplicate
    bam_ch = personal_mapping_ch.map { tupla ->
    def sample_id = tupla[0]
    def bam_path = tupla[2]
    return tuple(sample_id, bam_path)
    }
    duplicate_ch = MARKDUPLICATE (bam_ch)

//AddOrReplaceGroup
    replace_ch = duplicate_ch.map { tupla ->
    def sample_id = tupla[0]
    def replace_bam = tupla[1]
    return tuple(sample_id, replace_bam)
    }
    addorreplace_ch = ADDORREPLACE (replace_ch)
//5th Variant Caller
    gatk_ch = VARIANTCALLER (addorreplace_ch, params.personal_ref)
    
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
    if (! params.personal_ref)  {
        log.warn("You need to provide a personal genome reference (--personal_ref)")
        fatal_error = true
    }
    if (! params.sp_ref) {
        log.warn("You need to provide a specie genome reference (--sp_ref)")
        fatal_error = true

    }
}
