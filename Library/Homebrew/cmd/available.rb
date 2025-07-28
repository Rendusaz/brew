# typed: strict
# frozen_string_literal: true

require "cli/parser"
require "formula"
require "cask/cask"
require "json"

module Homebrew
  class Parser < CLI::Parser
    sig { void }
    def initialize
      super
      @description = "List all available formulae and casks in a clean format."

      switch "--casks",
            description: "List only casks."
      switch "--formulae",
            description: "List only formulae."
      switch "--json",
            description: "Output in clean JSON format."
      switch "--deps",
            description: "Include dependencies and dependents in JSON output."

      named_args :none
    end
  end

  module Available
    class << self
      extend T::Sig

      sig { params(args: CLI::Parser::Result).returns(T::Array[T::Hash[Symbol, T.untyped]]) }
      def gather_items(args)
        items = T.let([], T::Array[T::Hash[Symbol, T.untyped]])

        if args.flag?("--casks")
          Cask::Cask.all.each do |cask|
            items << build_item(cask, "cask", args.flag?("--deps"))
          end
        elsif args.flag?("--formulae")
          Formula.all.each do |formula|
            items << build_item(formula, "formula", args.flag?("--deps"))
          end
        else
          Formula.all.each do |formula|
            items << build_item(formula, "formula", args.flag?("--deps"))
          end
          Cask::Cask.all.each do |cask|
            items << build_item(cask, "cask", args.flag?("--deps"))
          end
        end

        items
      end

      sig { params(obj: T.untyped, type: String, include_deps: T::Boolean).returns(T::Hash[Symbol, T.untyped]) }
      def build_item(obj, type, include_deps)
        {
          type: type,
          name: obj.respond_to?(:token) ? obj.token : obj.name,
          version: obj.version.to_s,
          info: obj.respond_to?(:desc) ? obj.desc : obj.name,
          outdated: obj.outdated?,
          installed: obj.installed?,
          path: obj.path.to_s,
          deps: include_deps ? (obj.respond_to?(:deps) ? obj.deps : []) : nil,
          dependents: include_deps ? (obj.respond_to?(:required_by) ? obj.required_by : []) : nil
        }.compact
      end
    end
  end

  extend T::Sig

  module_function

  sig { void }
  def available
    parser = Parser.new
    args = T.let(parser.parse, CLI::Parser::Result)
    items = Available.gather_items(args)

    if args.flag?("--json")
      puts JSON.pretty_generate(items)
    else
      items.each do |item|
        puts "#{item[:type]}: #{item[:name]} (#{item[:version]}) - #{item[:info]}"
      end
    end
  end
end

      private

      sig { params(obj: T.untyped, type: String, include_deps: T::Boolean).returns(T::Hash[Symbol, T.untyped]) }
      def build_item(obj, type, include_deps)
        {
          type: type,
          name: obj.respond_to?(:token) ? obj.token : obj.name,
          version: obj.version.to_s,
          info: obj.respond_to?(:desc) ? obj.desc : obj.name,
          outdated: obj.outdated?,
          installed: obj.installed?,
          path: obj.path.to_s,
          deps: include_deps ? (obj.respond_to?(:deps) ? obj.deps : []) : nil,
          dependents: include_deps ? (obj.respond_to?(:required_by) ? obj.required_by : []) : nil
        }.compact
      end
    end
  end
end

      private

      sig { params(obj: T.untyped, type: String, include_deps: T::Boolean).returns(T::Hash[Symbol, T.untyped]) }
      def build_item(obj, type, include_deps)
        {
          type: type,
          name: obj.respond_to?(:token) ? obj.token : obj.name,
          version: obj.version.to_s,
          info: obj.respond_to?(:desc) ? obj.desc : obj.name,
          outdated: obj.outdated?,
          installed: obj.installed?,
          path: obj.path.to_s,
          deps: include_deps ? (obj.respond_to?(:deps) ? obj.deps : []) : nil,
          dependents: include_deps ? (obj.respond_to?(:required_by) ? obj.required_by : []) : nil
        }.compact
      end
    end
  end
end
    args = available_args.parse
  cmd_args do
    description "List all available formulae and casks in a clean format."
    switch "--casks", description: "List only casks."
    switch "--formulae", description: "List only formulae."
    switch "--json", description: "Output in clean JSON format."
    switch "--deps", description: "Include dependencies and dependents in JSON output."
    named_args :none
  end

  sig { override.void }
  def run
    args = cmd_args.parse
    puts "Debug - args class: #{args.class}"
    puts "Debug - args methods: #{args.methods - Object.methods}"
    puts "Debug - args inspection: #{args.inspect}"

    items = []

    if args.options.include?("--casks")
      casks = Cask::Cask.all
      casks.each do |cask|
        items << build_item(cask, "cask", args.options.include?("--deps"))
      end
    elsif args.options.include?("--formulae")
      Formula.all.each do |formula|
        items << build_item(formula, "formula", args.options.include?("--deps"))
      end
    else
      Formula.all.each do |formula|
        items << build_item(formula, "formula", args.options.include?("--deps"))
      end
      casks = Cask::Cask.all
      casks.each do |cask|
        items << build_item(cask, "cask", args.options.include?("--deps"))
      end
    end

    if args.options.include?("--json")
      puts JSON.pretty_generate(items)
    else
      items.each do |item|
        puts "#{item[:type]}: #{item[:name]} (#{item[:version]}) - #{item[:info]}"
      end
    end
  end

  private

  sig { params(obj: T.untyped, type: String, include_deps: T::Boolean).returns(T::Hash[String, T.untyped]) }
  def build_item(obj, type, include_deps)
    {
      type: type,
      name: obj.respond_to?(:token) ? obj.token : obj.name,
      version: obj.version.to_s,
      info: obj.respond_to?(:desc) ? obj.desc : obj.name,
      outdated: obj.outdated?,
      installed: obj.installed?,
      path: obj.path.to_s,
      deps: include_deps ? (obj.respond_to?(:deps) ? obj.deps : []) : nil,
      dependents: include_deps ? (obj.respond_to?(:required_by) ? obj.required_by : []) : nil
    }.compact
  end
end
