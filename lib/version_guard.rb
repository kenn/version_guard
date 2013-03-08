require 'version_guard/version'

module VersionGuard
  class << self
    def abort(target, requirement, options = {})
      Checker.new(target, requirement, options).abort_if_fail
    end

    def check(target, requirement, options = {})
      Checker.new(target, requirement, options).check
    end
  end

  class Checker
    def initialize(target, requirement, options = {})
      if target.nil? or requirement.nil? or target.empty? or requirement.empty?
        raise Error, 'target and requirement cannot be nil'
      end

      @requirement = requirement
      @options = options

      @version = begin
        Gem::Version.new(target) # raise ArgumentError unless target is like '1.2.3'
        target
      rescue ArgumentError
        # constantize string like 'ActiveRecord::VERSION::STRING'
        names = target.split('::')
        names.shift if names.empty? || names.first.empty? # Normalize ::TOPLEVEL
        @options[:name] ||= names.first
        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end
    end

    def check
      requirements = @requirement.is_a?(Array) ? @requirement : [@requirement]
      Gem::Version::Requirement.new(requirements).satisfied_by?(Gem::Version.new(@version))
    end

    def abort_if_fail
      if check
        puts "#{message_base} passed" if @options[:verbose]
      else
        trace = caller.find{|i| i !~ /version_guard\.rb/ }
        filename, lineno = trace.split(':')[0..1]
        abort "#{message_base} failed - check line #{lineno} in #{filename}"
      end
    end

    def message_base
      if @options[:name]
        "Version check for #{@options[:name]} (#{@version.inspect} with #{@requirement.inspect})"
      else
        "Version check #{@version.inspect} with #{@requirement.inspect}"
      end
    end
  end

  Error = Class.new(StandardError)
end
