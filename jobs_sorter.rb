# frozen_string_literal: true

require 'json'

module JobsSorter
  extend self

  def run(input)
    return [] if input.empty?
    structure = JSON.parse(input)

    [].tap do |arr|
      structure.each do |job, dependency|
        next if arr.include?(job)
        next arr.push(job) if dependency.nil?
        validate_dependency(job, dependency)
        arr.push(*resolve_dependencies(job, structure), job)
      end
    end.uniq
  end

  private

  def resolve_dependencies(job, jobs)
    [].tap do |chain|
      loop do
        validate_dependency_chain(chain)
        dependency = jobs.fetch(job)
        break if dependency.nil?
        chain.push(dependency)
        job = dependency
      end
    end.reverse
  end

  def validate_dependency(job, dependency)
    raise ArgumentError, "Jobs can't depend on themselves" if job == dependency
  end

  def validate_dependency_chain(chain)
    raise ArgumentError, "Jobs dependencies can't loop" if chain.uniq != chain
  end
end