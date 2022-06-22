#!/usr/bin/env ruby

def irbrc_error; @irbrc_error; end
def rails_init_error; @rails_init_error; end

begin
  require "date"
  require "etc"
  require "fileutils"
  require "pathname"
  require "pp"

  HOME ||= Pathname.new(Dir.home).freeze
  USER ||= Etc.getlogin.freeze

  UNAME ||= %x{uname -a}.chomp.freeze

  def pwd
    Dir.pwd
  end

  def try_block
    begin
      yield
    rescue StandardError => error
      error
    end
  end

  def try_require(lib_name, &block)
    require lib_name
    if block_given?
      try_block { yield }
    end
  rescue LoadError => error
    error
  end

  puts <<-EOT
#{RUBY_DESCRIPTION}

  EOT

  try_require "readline"
  try_require "awesome_print"
  try_require "irb/completion"

  history_file =
    if defined?(IRB) && IRB.respond_to?(:conf)
      IRB.conf[:HISTORY_FILE]
    end
  history_file ||= "#{HOME}/.irb-history"
  save_history   = 200_000

  try_require("irb/ext/save-history") do
    history_lines = `wc -l "#{history_file}"`.to_i
    if history_lines.to_f / save_history > 0.8
      puts "Rolling IRB history file"
      last_20 = `tail -n #{(save_history / 5.0).to_i} "#{history_file}"`

      history_dir = "#{history_file}.d"
      dest = "#{history_dir}/irb-history-#{Date.today.strftime("%Y%m%d")}"
      Dir.mkdir(history_dir) unless File.directory?(history_dir)

      File.rename(history_file, dest)
      puts "Existing history was saved to '#{dest}'"
      File.write(history_file, last_20)
    end

    IRB.conf[:SAVE_HISTORY] = save_history
  end


  if defined?(Pry)
    Pry.config.history_file = history_file
  end

  try_require("hirb") do
    Hirb.enable
  end

  try_require("hirber") do
    Hirb.enable
  end

  if defined?(Rails)
    if (Rails.env.development? || Rails.env.test?)
      result = try_block do
        Rails.application&.eager_load!
      end
      if result.is_a?(StandardError)
        @rails_init_error = result
        puts <<~EOT
          Error loading Rails application: #{result}
          Error stored in 'rails_init_error'
        EOT
      end
    end
    if defined?(ActiveRecord) && !Rails.env.production? && ActiveRecord::Base.logger
      # https://stackoverflow.com/a/17675841
      ActiveRecord::Base.logger.level = 0
    end
  end

  def cls; puts "\033c\033[3J"; end

  def bel
    print "\07"
  end

  def bprint(text)
    print "\033[1m#{text}\033[0m"
  end

  def cprint_q(color256, text)
    "\033[38;5;#{color256}m#{text}\033[0m"
  end

  def cprint(*args)
    print cprint_q(*args)
  end

  %:hello world:

  try_block do
    IRB.conf[:USE_SINGLELINE] = true  # Turn off reline
    IRB.conf[:PROMPT][:CUSTOM] = {
      PROMPT_I:    "[#{cprint_q 2, "%03n"  }]: ",
      PROMPT_S:    "[#{cprint_q 2, "%03n%l"}]: ",
      PROMPT_C:    "[#{cprint_q 2, "%03n"  }]: ",
      PROMPT_N:    "[#{cprint_q 2, "%03n?" }]: ",
      RETURN:      " # => %s \n",
      AUTO_INDENT: true
    }
    IRB.conf[:PROMPT_MODE] = :CUSTOM
  end

  at_exit do
    try_block do
      line_no = IRB.CurrentContext.io.instance_variable_get(:@line_no) + 1
      puts("[#{cprint_q 1, "%03d" % line_no}]:")
    end
  end

  # Re-implementation of `silence_stream` that was removed in Rails 5 due to it not being threadsafe.
  # This is not threadsafe either so only use it in single threaded operations.
  # See https://api.rubyonrails.org/v4.2.5/classes/Kernel.html#method-i-silence_stream.
  def silence_stream(stream)
    old_stream = stream.dup
    stream.reopen(File::NULL)
    stream.sync = true
    yield
  ensure
    stream.reopen(old_stream)
    old_stream.close
  end

  def suppress_stdout
    silence_stream(STDOUT) { yield }
  end

  def source_file(path)
    suppress_stdout do
      source path
    end
  end

  def require_lib(lib_name)
    lib = File.join(Dir.pwd, "lib")
    $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
    require lib_name
  end

  def bundler_setup
    require "bundler/setup"
    Bundler.require
  end

  def to_money(val)
    "$%.2f" % val.to_f.round(2)
  end

  def mock_hash(size = 10)
    hash = { }
    i = 0
    while hash.size < size
      letters = i.to_s(26)
      i += 1
      next if letters =~ /^\d/
      hash[letters.to_sym] = hash.size + 1
    end
    hash
  end

  # Object methods
  def omethods(instance, *compare_classes)
    subtract_methods = Object.instance_methods

    compare_classes.each { |klass| subtract_methods += klass.instance_methods }
    subtract_methods.uniq!

    diff = instance.public_send(:methods) - subtract_methods
    cmd  = defined?(AwesomePrint) ? :ap : :pp
    __send__(cmd, diff)
  end

  def tally(arr)
    arr.group_by(&:itself).transform_values(&:count)
  end

  def load_record(klass, identifier)
    identifier.is_a?(klass) ? identifier : klass.find(identifier)
  end

  def timeit(&block)
    format = "%F %T.%6N %z"
    handle_finish = lambda do |start|
      finish = Time.now
      puts <<~EOT
        Finish time: #{finish.strftime(format)}
        Total time:  #{finish - start} seconds

      EOT
    end
    start = Time.now
    puts "Start time:  #{start.strftime(format)}"
    result = block.call
    handle_finish.call(start)
    result
  rescue StandardError => error
    handle_finish.call(start)
    error
  end

  # https://stackoverflow.com/questions/2772778/parse-a-string-as-if-it-were-a-querystring-in-ruby-on-rails
  def parse_qs(string)
    Rack::Utils.parse_nested_query(string)
  end

  def isbn13_checksum(*arr)
    arr.
      map.with_index(1) { |x, i| x * ( i.odd? ? 1 : 3 ) }.
      sum.
      then { |s| s % 10 }.
      then { |n| (10 - n) % 10 }
  end

  irbrc_local = File.join(HOME, ".irbrc.local")
  if File.file?(irbrc_local)
    load irbrc_local
  end
rescue StandardError => error
  @irbrc_error = error
  puts "WARN: Error occurred during irbrc load"
  puts error.message
  puts "Error saved to +irbrc_error+"
end
