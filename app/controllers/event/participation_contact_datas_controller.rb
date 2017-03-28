class Event::ParticipationContactDatasController < ApplicationController

  # required for nesting
  def model_scope
    Person.none
  end

  def path_args
    nil
  end

  include Nestable
  self.nesting = Group, Event

  helper_method :group, :event, :entry

  authorize_resource :entry, class: Event::ParticipationContactData

  decorates :group, :event

  before_action :set_entry, :group

  def edit; end

  def update
    if entry.save
      redirect_to new_group_event_participation_path(group, event,
                                                     event_role: { type: params[:event_role][:type] })
    else
      render :edit
    end
  end

  private

  attr_reader :entry

  def build_entry
    Event::ParticipationContactData.new(event, current_user)
  end

  def set_entry
    @entry = if params[:event_participation_contact_data]
               Event::ParticipationContactData.new(event, current_user, model_params)
             else
               build_entry
             end
    @participation_contact_data = @entry
  end

  def event
    @event ||= Event.find(params[:event_id])
  end

  def group
    @group ||= Group.find(params[:group_id])
  end

  def model_params
    params.require('event_participation_contact_data').permit(permitted_attrs)
  end

  def permitted_attrs
    PeopleController.permitted_attrs
  end


end
