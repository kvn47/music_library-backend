module Album::Representer
  class Base < BaseRepresenter
    property :id
    property :title
    property :url, exec_context: :decorator
    property :cover_thumb_url

    def url
      "/albums/#{represented.id}"
    end
  end
end