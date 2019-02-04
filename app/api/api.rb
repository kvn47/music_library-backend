# frozen_string_literal: true

class API < Grape::API
  default_format :json
  helpers ActionsHelpers

  mount ToolsAPI => '/tools'
end
