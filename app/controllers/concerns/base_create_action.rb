module BaseCreateAction
  def create
    run CreateModel, step_args: {validate: [contract], create: [model_class]} do |m|
      m.success { |model| represent model, status: :created }
      m.failure { |error| render_error error }
    end
  end
end
