# frozen_string_literal: true

class WorkInfoPresenter < Grape::Entity
  expose :mb_id
  expose :title
  expose :url
  expose :composer
  expose :composer_url
  expose :date
  expose :parts
  expose :albums do
    expose :number
    expose :title
    expose :url
  end
end
