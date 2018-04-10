require 'json'
require 'byebug'

module JobsSorter
  module_function

  def run(input)
    return [] if input.empty?
    structure = JSON.parse(input)

    [].tap do |arr|
      structure.each do |job, dependency|
        next if arr.index(job)
        next arr.push(job) if dependency.nil?
        arr.push(*resolve_dependency(job, structure), job)
      end
    end.uniq
  end

  def resolve_dependency(job, jobs)
    dependency = jobs.fetch(job)
    return [] if dependency.nil?
    [resolve_dependency(dependency, jobs), dependency].flatten
  end
end