require 'erb'
require 'fileutils'
require 'pathname'

class Setup
  # Symlink dotfiles to ENV['HOME'] or ENV['DOTFILES_HOME']
  def install
    check_install_dest

    update
    process_erbs
    create_symlinks
  end

  # Uninstall symlinked dotfiles from ENV['HOME'] or ENV['DOTFILES_HOME']"
  def uninstall
    check_install_dest

    Dir.glob("**/*{.symlink}").each do |link_dest|
      link_src_full_path = get_symlink_location link_dest, false

      # Remove all symlinks created during installation
      if File.symlink? link_src_full_path
        puts "Removing symlink at #{link_src_full_path}"
        FileUtils.rm link_src_full_path
      end

      # Recover any backups made during installation
      backup_file = "#{link_src_full_path}.backup"
      if File.exists? backup_file
        puts "Recovering original file #{link_src_full_path} from #{backup_file}"
        `mv "#{backup_file}" "#{link_src_full_path}"`
      end
    end
  end

  # Get any updates from the dotfiles repo on GitHub
  def update
    # check that we've got a clean working directory. Git can't pull
    # updates with a dirty working directory.
    unless `git status --porcelain`.empty?
      puts "Can't proceed: the working directory is dirty. Please stash, "
      puts "commit, or reset any changes listed in `git status`."

      exit 1
    end

    puts "Pulling latest changes from GitHub..."
    `git pull > /dev/null`

    puts "Synchronizing git submodule URLs..."
    `git submodule sync > /dev/null`

    puts "Fetching any newly added git submodules..."
    `git submodule update --init > /dev/null`
  end

  #####################################################################
  # Helpers
  #####################################################################
  def create_symlinks
    skip_all = false
    overwrite_all = false
    backup_all = false

    Dir.glob("**/*{.symlink}").each do |link_dest|
      overwrite = false
      backup = false

      file_name = File.basename link_dest, ".symlink"

      # Symlink direction: link_src -> link_dest
      link_src_full_path = get_symlink_location link_dest, true
      link_dest_full_path = File.expand_path link_dest

      # Handle pre-existing dotfiles (create backup, overwrite, etc)
      if File.exists?(link_src_full_path) || File.symlink?(link_src_full_path)
        if File.identical? link_src_full_path, link_dest_full_path
          puts "Skipping identical file #{link_src_full_path}"
          next
        end

        unless skip_all || overwrite_all || backup_all
          puts "File already exists: #{link_src_full_path}, what do you want to do?"
          puts "[s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all, or [q]uit"

          case STDIN.gets.chomp
          when 'o' then overwrite = true
          when 'b' then backup = true
          when 'O' then overwrite_all = true
          when 'B' then backup_all = true
          when 'S' then skip_all = true
          when 's' then next
          when 'q' then exit
          else
            puts "Unrecognized command, quitting."
            exit
          end
        end

        if skip_all
          puts "Skipping #{link_src_full_path}"
          next
        end

        if overwrite || overwrite_all
          puts "Overwriting #{link_src_full_path}"
          FileUtils.rm_rf link_src_full_path
        end

        if backup || backup_all
          backup_file = "#{link_src_full_path}.backup"
          backup_file_exists = File.exists?(backup_file) || File.symlink?(backup_file)

          unless backup_file_exists
            puts "Backing up #{link_src_full_path} to #{backup_file}"
            `mv "#{link_src_full_path}" "#{backup_file}"`
          else
            puts "Can't backup #{link_src_full_path} to #{backup_file} => the destination already exists"
          end
        end
      end

      # use the -n option to allow replacing a symbolic link which points to a directory
      puts "Linking #{link_src_full_path} to #{link_dest_full_path}"
      `ln -ns "#{link_dest_full_path}" "#{link_src_full_path}" 2>/dev/null`
    end
  end

  def process_erbs
    erb_files = Dir.glob("*/**{.erb}")
    return if erb_files.empty?

    generated_dir_name = "generated"
    FileUtils.mkdir_p generated_dir_name

    erb_files.each do |erb_file|

      regenerate = false
      generated_file_name = File.join generated_dir_name, File.basename(erb_file, ".erb")

      if File.exists? generated_file_name
        puts "GENERATED file already exists: #{generated_file_name}, what do you want to do?"
        puts "[r]egenerate and overwrite, [l]eave existing file alone, or [q]uit"

        case STDIN.gets.chomp
        when 'r' then regenerate = true
        when 'l' then next
        when 'q' then exit
        else
          puts "Unrecognized command, quitting."
          exit
        end
      end

      if regenerate
        puts "Regenerating #{generated_file_name}"
      else
        puts "Generated #{generated_file_name}"
      end

      # Please the closure gods
      b = binding

      File.open(generated_file_name, "w") do |new_file|
        new_file.write ERB.new(IO.read(erb_file)).result(b)
      end

    end
  end

  # allow overriding of install destination (for ease of testing)
  # Example: DOTFILES_HOME=/tmp/test_dir rake install
  def install_dest
    ENV["DOTFILES_HOME"] || ENV["HOME"]
  end

  def check_install_dest
    if File.exists? install_dest
      abort "Destination #{install_dest} isn't a directory!" unless File.directory? install_dest
      abort "Destination #{install_dest} isn't writable!" unless File.writable? install_dest
    else
      abort "Destination #{install_dest} doesn't exist!"
    end
  end

  def get_symlink_location(link_dest, create_missing_parent_dirs)
    normal_location = File.join install_dest, ".#{File.basename link_dest, '.symlink'}"

    if File.file?(link_dest) && (override_match = File.read(link_dest).match(/^#\s*DOTFILES_SYMLINK_LOCATION:\s*(\S+)\s*$/))
      override_location = override_match.captures[0].gsub('${DOTFILES_HOME}', install_dest)
      puts "A symlink location override exists for dotfile '#{link_dest}': using '#{override_location}' instead of '#{normal_location}'"

      override_location_as_path = Pathname.new override_location

      # Ensure that override_location is an absolute path
      raise "Overridden symlink location must be an absolute path" unless override_location_as_path.absolute?

      if create_missing_parent_dirs
        puts "Creating any missing parent directores for symlink override path #{override_location}"
        override_location_as_path.dirname.mkpath
      end

      return override_location
    else
      return normal_location
    end
  end
end

if __FILE__ == $0
  setup = Setup.new
  print_usage = false

  if ARGV.size == 0
    setup.install
  elsif ARGV.size == 1
    case ARGV[0].downcase
    when "install"
      setup.install
    when "update"
      setup.update
    when "uninstall"
      setup.uninstall
    else
      print_usage = true
    end
  end

  if print_usage
    puts <<USAGE_END
Usage: setup.rb [ACTION]

Valid ACTIONs:
    install (default)      Install Dotfiles to your Home directory. Existing files
                           are backed up before they're overwritten (and are reverted
                           when Dotfiles is uninstalled).
    update                 Update installed Dotfiles.
    uninstall              Uninstall Dotfiles and revert backup files.
    help                   Print this message.
USAGE_END
  end
end
