class NotesController < ApplicationController
  include ModelController

  # def index
  #   run Note::Index do
  #     return represent Note::Representer::Base.for_collection
  #   end
  #   render_error
  # end

  # def show
  #   run Note::Show do
  #     return represent Note::Representer::Show
  #   end
  #   render_error
  # end

  # def create
  #   CreateModel.new(validate: ValidateModel.new).with_step_args(validate: [NoteContract], create: [Note]).(**params_hash) do |r|
  #     r.success { |note| represent(Note::Representer::Base, note)}
  #     r.failure { |error| render_error(error) }
  #   end
  # end

  # def update
  #   UpdateModel.new(validate: ValidateParams.new).with_step_args(validate: [NoteContract], update: [Note]).(**params_hash) do |r|
  #     r.success { |note| represent(Note::Representer::Base, note)}
  #     r.failure { |error| render_error(error) }
  #   end
  # end

  # def destroy
  #   run Note::Delete do
  #     return render json: params.slice(:id)
  #   end
  #   render_error
  # end

  private

  def contract; NoteContract end

  def model_class; Note end

  def serializer_class; NoteSerializer end
end
