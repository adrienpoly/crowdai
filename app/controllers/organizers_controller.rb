class OrganizersController < ApplicationController
  before_action :authenticate_participant!
  before_action :set_organizer, only: [:show, :edit, :update, :destroy]
  after_action :verify_authorized

  def show
    @challenges = @organizer.challenges
  end

  def edit
  end

  def create
    @organizer = Organizer.new(organizer_params)
    authorize @organizer

    if @organizer.save
      if current_participant.admin?
        redirect_to @organizer, notice: "Organizer has been created."
      else
        current_participant.organizer = @organizer
        current_participant.save!
        redirect_to @organizer, notice: "The request to host challenges has been submitted. After review, you will be notified when #{@organizer.organizer} may begin to host challenges."
      end
    else
      render :new
    end
  end

  def update
    if @organizer.update(organizer_params)
      redirect_to @organizer, notice: 'Hosting organizer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @organizer.destroy
    redirect_to organizers_url, notice: 'Hosting organizer was successfully destroyed.'
  end

  def members
    @organizer = Organizer.friendly.find(params[:organizer_id])
    authorize @organizer
    @members = @organizer.participants
  end

  def remove_image
    @organizer = Organizer.friendly.find(params[:organizer_id])
    @organizer.remove_image_file!
    @organizer.save
    redirect_to edit_organizer_path(@organizer),notice: 'Image removed.'
  end

  def regen_api_key
    @organizer = Organizer.friendly.find(params[:organizer_id])
    authorize @organizer
    @organizer.api_key = @organizer.generate_api_key
    @organizer.save!
    redirect_to edit_organizer_path(@organizer),notice: 'API Key regenerated.'
  end

  private
    def set_organizer
      @organizer = Organizer.friendly.find(params[:id])
      authorize @organizer
    end

    def organizer_params
      params.require(:organizer)
            .permit(:organizer,
                    :address,
                    :description,
                    :approved,
                    :organizer_id,
                    :status,
                    :tagline,
                    :image_file,
                    :clef_organizer,
                    tasks_attributes: [
                      :id, :_delete, :task
                    ])
    end
end
