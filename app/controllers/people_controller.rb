class PeopleController < ApplicationController
  def index
    @locations = Location.visible
    @people    = Person.active.order(:last_name)
  end

  def show
    @person = Person.find_by(slug: params[:id])

    unless @person
      redirect_to(people_path, error: 'We could not find the portfolio you were trying to reach.')
    end
  end

  before_action :require_login, only: [:new, :create, :edit, :update]

  def new
    @person = Person.new
  end

  def create
    @person = Person.find_or_create_by(user_github_id: current_user.github_id)

    if @person.update_attributes(person_params)
      redirect_to person_path(@person), notice: 'Your portfolio was created.'
    else
      flash.now[:error] = 'Your portfolio could not be created. Please try again.'
      render :new
    end
  end

  def edit
    @person = current_person
  end

  def update
    @person = current_person

    if @person.update_attributes(person_params)
      redirect_to person_path(@person), notice: 'Your portfolio was updated.'
    else
      flash.now[:error] = 'Your portfolio could not be updated. Please try again.'
      render :edit
    end
  end

  private

  def person_params
    params.require(:person).permit(
      :first_name,
      :last_name,
      :email_address,
      :github_url,
      :looking_for,
      :best_at,
      :cohort_id,
      :photo_slug,
      :hidden,
      :introduction,
      :hired,
      :hired_by
      )
  end
end
