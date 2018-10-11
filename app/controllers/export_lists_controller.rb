class ExportListsController < ApplicationController
  include BaseCreateAction
  include BaseIndexAction
  include BaseShowAction
  include BaseUpdateAction
  include BaseDestroyAction

  def add
    run ExportList::AddTracks do |m|
      m.success { |export_list| represent export_list }
      m.failure { |error| render_error error }
    end
  end

  def remove
    run ExportList::RemoveTrack do |m|
      m.success { |export_list| represent export_list }
      m.failure { |error| render_error error }
    end
  end

  def clear
    run ExportList::Clear do |m|
      m.success { |export_list| represent export_list }
      m.failure { |error| render_error error }
    end
  end

  def export
    run ExportList::Export do |m|
      m.success { |export_list| represent export_list }
      m.failure { |error| render_error error }
    end
  end
end
