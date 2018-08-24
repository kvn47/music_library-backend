AlbumContract = AContract.define do
  required(:title).filled
  required(:artist_id).filled(:int?)
end
