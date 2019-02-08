class ExportListPresenter < Grape::Entity
  expose :id
  expose :name
  expose :destination_path
  expose :created_at
  expose :updated_at
  expose :fullness
  expose :capacity
  expose :size
  expose :tracks, using: TrackPresenter, if: { type: :full }

  private

  include ActiveSupport::NumberHelper

  def capacity
    return I18n.t('export_list.capacity.unlimited') if object.capacity.nil?
    number_to_human_size object.capacity.gigabytes
  end

  def size
    number_to_human_size object.size
  end
end
