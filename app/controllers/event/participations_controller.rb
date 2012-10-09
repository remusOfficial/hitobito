class Event::ParticipationsController < CrudController
  self.nesting = Event
  
  decorates :event, :participation, :participations, :priority_2s
  
  # load event before authorization
  prepend_before_filter :parent, :set_group
  before_render_form :load_priorities
  before_render_show :load_answers
  
  
  def new
    assign_attributes
    entry.init_answers
    respond_with(entry)
  end
  
=begin
  def create
    super(location: event_participations_path(entry.event_id))
  end
  
  def update
    super(location: event_participation_path(entry.event_id, entry.id))
  end
  
  def destroy
    super(location: event_participations_path(entry.event_id))
  end
=end
    
    
  def authorize!(action, *args)
    if [:index, :show].include?(action)
      super(:index_participations, parent)
    else
      super
    end
  end
  
  private
    
  def list_entries(action = :index)
    records = parent.participations.
                 where(event_participations: {active: true}).
                 includes(:person, :roles).
                 order_by_role(parent.class).
                 merge(Person.order_by_name)
    Person::PreloadPublicAccounts.for(records.collect(&:person))
    records
  end
  
  
  # new and create are only invoked by people who wish to
  # apply for an event themselves. A participation for somebody
  # else is created through event roles. 
  def build_entry
    participation = parent.participations.new
    participation.person = current_user
    if parent.supports_applications
      appl = participation.build_application
      appl.priority_1 = parent
    end
    participation
  end
  
  def assign_attributes
    super
    # Set these attrs again as a new application instance might have been created by the mass assignment.
    entry.application.priority_1 ||= parent if entry.application
  end
  
  def set_group
    @group = parent.group
  end
    
  def load_priorities
    if entry.application && entry.event.priorization
      @priority_2s = @priority_3s = Event::Course.list(parent.dates.first.try(:start_at).try(:year)).
                                                  where(kind_id: parent.kind_id).
                                                  in_hierarchy(current_user)
    end
  end
  
  def load_answers
    @answers = entry.answers.includes(:question)
  end
  
  # A label for the current entry, including the model name, used for flash
  def full_entry_label
    "#{models_label(false)} #{Event::ParticipationDecorator.decorate(entry).flash_info}".html_safe
  end
  
  class << self
    def model_class
      Event::Participation
    end
  end
end