class Selection

  def fasta_to_hash(file_path)
    Bio::FlatFile.auto(file_path){ |f| f.map {|entry| Hash.[](entry.definition.to_sym,[entry.seq.to_s])} }  
  end

  #given an array return the indices of the most different elements
  def index_of_least_identical(array)
    freq_hash = array.inject(Hash.new(0)) { |k,v| k[v] += 1; k }
    most_freq = array.sort_by { |v| freq_hash[v] }.last
    array.each_index.map {|i| i+1 if array[i] != most_freq}
  end

  def get_codons(seq)
    codons = []
    seq.window_search(3,3) {|c| codons.push c}
    codons
  end

  def get_aa(seq)
    get_codons(seq).map {|codon| codon.translate}
  end

  def get_seqs(seqs)
    codon_arrays = []
    seqs.each do |seq|
      seq.each do |k,v|
        bioseq = Bio::Sequence::NA.new(v.pop)
        codon_arrays << get_codons(bioseq)
      end
    end
    codon_arrays
  end

  def get_column_as_string(data,column)
    #len = data.first.size
    data.map{|item| item[column]}.join('')
  end
end

#file_path = "#{ENV['HOME']}/Batch2/batch2_cafs/pipeline2/example.fasta"
file_path = "#{ENV['HOME']}/BGI_data/analysis/clustering/cd-hit/98/cluster2489/cluster_2489.fasta"

selection = Selection.new

hash_data = selection.fasta_to_hash(file_path)

data  = selection.get_seqs(hash_data)

column_seq = selection.get_column_as_string(data,0)

bioseq = Bio::Sequence::NA.new(column_seq)

codons = selection.get_codons(bioseq)

#puts codons.inspect

puts selection.get_aa(bioseq).inspect

#puts selection.index_of_least_identical(codons).compact.inspect

#create an instance of a standard codon table
#t = Bio::CodonTable[1]
#puts t.inspect
#TODO detemine the whether a site is synonymous or non-synonymous


