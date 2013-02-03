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

  #get nucleotide frequencies at each position
  def nucleotide_freq
    seq_al.columns.map do |column|
      column.to_s.split(//).inject(Hash.new(0)) { |h,v| h[v] += 1; h } #.to_a.flatten.map{|c| c.join('')}
    end
  end

  def entropy

  end

end

file = "#{ENV['HOME']}/BGI_data/cluster/cd-hit/98/cluster_550/cluster_550.aln"

popgen = PopGen.new(file)

p popgen.nucleotide_freq

