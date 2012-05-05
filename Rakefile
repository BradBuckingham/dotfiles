require 'rake'
require 'erb'
require 'fileutils'

desc "Symlink dotfiles to ENV['HOME'] or ENV['DOTFILES_HOME']"
task :install do
  check_install_dest

  process_erbs
  create_symlinks
end
task :default => :install

desc "Uninstall symlinked dotfiles from ENV['HOME'] or ENV['DOTFILES_HOME']"
task :uninstall do
  check_install_dest

  Dir.glob("**/*{.symlink}").each do |link_dest|
    file_name = File.basename link_dest, ".symlink"
    link_src_full_path = File.join install_dest, ".#{file_name}"

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

def create_symlinks
  skip_all = false
  overwrite_all = false
  backup_all = false

  Dir.glob("**/*{.symlink}").each do |link_dest|
    overwrite = false
    backup = false

    file_name = File.basename link_dest, ".symlink"

    # Symlink direction: link_src -> link_dest
    link_src_full_path = File.join install_dest, ".#{file_name}"
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
        else exit
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
    # Please the closure gods
    b = binding

    generated_file_name = File.join generated_dir_name, File.basename(erb_file, ".erb")
    File.open(generated_file_name, "w") do |new_file|
      new_file.write ERB.new(IO.read(erb_file)).result(b)
    end

    puts "Generated #{generated_file_name}"
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