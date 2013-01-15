require 'bio'

class Mutation
  attr_reader :subjects,:changes

  #convert a fasta file to a hash
  def fasta_to_hash(file_path)
    Bio::FlatFile.auto(file_path){ |f| f.map {|entry| Hash.[](entry.definition.to_sym,[entry.seq.to_s])} }
  end

  #input is an array of hashes
  def locate_mismatches(data)
    @changes = []
    @subjects = []
    data.combination(2).to_a.map do |pair| 
      @subjects << "seqs: #{pair[0].keys.flatten.pop}:#{pair[1].keys.flatten.pop}"
      change = pair[0].values.flatten.pop.chars.zip(pair[1].values
                                                    .flatten.pop.chars).each_with_index.map{|item| item.uniq}
                                                    .each_with_index
                                                    .map{|a,index| [index+1,a] unless a.size == 1}.compact
                                                    .map{|h| Hash[*h]}
                                                    @changes << change
    end
    @changes
  end

  def subjects
    @subjects
  end

  def changes
    @changes
  end

  def purine?(base)
    true if base =~ /[ga]/
  end

  def pyrimidine?(base)
    true if base =~ /[ct]/
  end

  def transversion?(bases)
    true if (purine?(bases.first) and pyrimidine?(bases.last)) || (pyrimidine?(bases.first) and purine?(bases.last))
  end

  def transition?(bases)
    true if (purine?(bases.first) and purine?(bases.last)) || (pyrimidine?(bases.first) and pyrimidine?(bases.last))
  end

  #given a location denote the type of change that is present at that location
  def nature_of_change(bases)
    if transition?(bases)
      return 'TI' #transition
    elsif transversion?(bases)
      return 'TV' #transversion
    else
      return 'error'
    end
  end

  #in which codon position did the change occur?
  def changed_codon_pos(pos)
    #codon position test using a divisibility with 3 test
    t1 = (pos - 1) % 3 == 0
    t2 = (pos + 1) % 3 == 0
    t3 = pos % 3 == 0

    #what is the codon number
    #c1 = ((pos - 1)/3) + 1
    #c2 = (pos + 1)/3
    #c3 = pos/3
    case
    when t1 then return 1
    when t2 then return 2
    when t3 then return 3
    else return "undetermined"
    end
  end

  def change_summary
    changes.map do |m|
      m.map do |pos|
        location  = pos.keys.pop
        residues  = pos.values.flatten.join('-')
        change    = nature_of_change(pos.values.flatten)
        codon_pos = changed_codon_pos(pos.keys.pop)
        "#{location},#{residues},#{change},#{codon_pos}"
        #"#{location},#{change},codon-#{codon_pos}"
      end
    end
  end
end

#file_path = "#{ENV['HOME']}/Batch2/batch2_cafs/pipeline2/example.fasta"

file_path = ARGV[0]
#initilize a class
mutation = Mutation.new

#get the data
data = mutation.fasta_to_hash(file_path)

#locate mismatches
mutation.locate_mismatches(data)

#output a summary of the differences
summary = mutation.change_summary

#which sequences did we analyse?
#puts mutation.subjects

#write the output to the command line. Can be piped to a file
puts summary
