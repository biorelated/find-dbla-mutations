require 'bio'
require File.join(File.expand_path(File.dirname(__FILE__)), 'mutation','mutation')
require File.join(File.expand_path(File.dirname(__FILE__)), 'selection','selection')

file_path = "#{ENV['HOME']}/Batch2/batch2_cafs/pipeline2/example.fasta"

#file_path = ARGV[0]
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
