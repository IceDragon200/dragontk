def Dir.crawl(name, context = nil, depth = 0, depth_limit = 30, &block)
  return if depth > depth_limit

  if File.directory?(name)
    (Dir.entries(name) - ['.', '..']).each do |fn|
      crawl(File.join(name, fn), context, depth + 1, depth_limit, &block)
    end
  else
    yield name, context, depth
  end

  context
end
