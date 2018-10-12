desc 'Structure album'
task :structure_album, [:path] => [:environment] do |t, args|
  StructureAlbumFiles.(path: args.path)

end
