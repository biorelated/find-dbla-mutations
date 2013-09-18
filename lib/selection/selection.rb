require 'bio'
require 'bio-alignment'
require 'bio-alignment/bioruby' # make Bio::Sequence enumerable
include Bio::BioAlignment

class PopGen

  def initialize(file)
    @file = file
  end

  def seq_al
    aln = Alignment.new
    Bio::FlatFile.auto(@file).each_entry do |entry|
      aln << Sequence.new(entry.definition,entry.seq)
    end
    aln
  end

  def codon_al
    codon_aln = Alignment.new
    Bio::FlatFile.auto(@file).each_entry do |entry|
      codon_aln << CodonSequence.new(entry.definition,entry.seq)
    end
    codon_aln
  end

  def print_codons
    codon_al.columns.map do |column|
      column
    end
  end

  #get nucleotide frequencies for each position
  def nucleotide_freq
    seq_al.columns.map do |column|
      gees = column.to_s.count('G')
      aaas = column.to_s.count('A')
      cees = column.to_s.count('C')
      tees = column.to_s.count('T')
      del  = column.to_s.count('-')
      "#{gees},#{aaas},#{cees},#{tees},#{del}"
      # [gees,aaas,cees,tees,del]
    end

  end
end
