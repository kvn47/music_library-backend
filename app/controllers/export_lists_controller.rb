class ExportListsController < BaseController
  def add
    run ExportList::AddTracks do |r|
      r.success { |export_list| represent export_list }
      r.failure { |error| render_error error }
    end
  end

  def remove
    run ExportList::RemoveTrack do |r|
      r.success { |export_list| represent export_list }
      r.failure { |error| render_error error }
    end
  end

  def clear
    run ExportList::Clear do |r|
      r.success { |export_list| represent export_list }
      r.failure { |error| render_error error }
    end
  end

  def export
    run ExportList::Export do |r|
      r.success { |export_list| represent export_list }
      r.failure { |error| render_error error }
    end
  end
end
