
file = "#{ENV['HOME']}/BGI_data/cluster/cd-hit/98/cluster_1033/cluster_1033.aln"
file = "#{ENV['HOME']}/BGI_data/cluster/cd-hit/98/cluster_550/cluster_550.aln"

require 'bio-alignment'

require 'bio-alignment/bioruby' # make Bio::Sequence enumerable
include Bio::BioAlignment

aln = Alignment.new

Bio::FlatFile.auto(file).each_entry do |entry|
  aln << Sequence.new(entry.definition,entry.seq)
end
aln.columns.each do |column|
  puts column.to_s.split(//).inject(Hash.new(0)) { |h,v| h[v] += 1; h }
end
