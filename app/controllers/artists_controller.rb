class ArtistsController < ApplicationController
  include BaseCreateAction
  include BaseIndexAction
  include BaseShowAction
  include BaseUpdateAction
  include BaseDestroyAction
end
