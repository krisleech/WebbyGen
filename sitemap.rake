task :generate_site do
  sitemap = YAML::load(ERB.new(IO.read('sitemap.yml')).result)
  path = '../content'
  generate_section(sitemap, path)
end


def generate_section(hash, path)

  hash.each do |k,v|        
    if folder?(v)
      new_path = File.join(path, k)
      if File.exists? new_path
        puts "#{new_path} [EXISTS]"
      else
        puts new_path
        Dir.mkdir(new_path)
      end
      generate_section(v, new_path) # recursive
    else
      new_file = File.join(path, k) + '.txt'
      if File.exists?(new_file) && !v['overwrite']==true
        puts "#{new_file} [EXISTS]"
      else
        puts new_file
        @title = v['title'] || 'untitled'
        @section = v['section'] || path.split('/').last.gsub('_', ' ').split(' ').each{|word| word.capitalize!}.join(' ')
        contents = ERB.new(File.read('./templates/page.erb')).result(binding)
        File.new(new_file, 'w').puts(contents)      
      end
    end

  end
end

def folder?(record)
  record['title'].nil?
end

# EOF
