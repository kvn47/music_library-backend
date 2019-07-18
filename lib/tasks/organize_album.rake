desc 'Organize music files'
task :organize_files, [:path] => [:environment] do |t, args|
  OrganizeFiles.(path: args.path)
end
