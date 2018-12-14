desc 'Structure album'
task :organize_album, [:path] => [:environment] do |t, args|
  OrganizeAlbumFiles.(path: args.path)

end
