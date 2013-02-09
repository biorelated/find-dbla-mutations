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
      "#{gees},#{aaas},#{cees},#{tees}"
      #column.to_s  #.split(//).inject(Hash.new(0)) { |h,v| h[v] += 1; h }
    end
  end

  def entropy

  end
end

file = "#{ENV['HOME']}/BGI_data/cluster/cd-hit/98/cluster_550/cluster_550.aln"
#file = "#{ENV['HOME']}/BGI_data/cluster/cd-hit/88/cluster_1290/cluster_1290.aln"
#file = "#{ENV['HOME']}/BGI_data/cluster/cd-hit/var1/98/cluster_1/cluster_1.aln"

popgen = PopGen.new(file)

#popgen.nucleotide_freq.each_with_index do |c,index|
  #puts "#{index + 1},#{c}"
#end

popgen.print_codons.each_with_index do |col,index|
  star = '*' if col.to_s.scan(/.{3}|.+/).uniq.size > 1
  amino = Bio::Sequence::NA.new(col.to_s).translate.split(//).uniq.join('')
  puts "#{index + 1} #{col.to_s.scan(/.{3}|.+/).join(' ')} #{amino} #{star}"
end
