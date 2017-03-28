require 'spec_helper'

describe Event::ParticipationContactDatasController do

  let(:group) { groups(:top_layer) }

  let(:course) do
    course = Fabricate(:course, groups: [group])
    #course.dates << Fabricate(:event_date, event: course)
    course
  end

  let(:user) { people(:top_leader) }

  before { sign_in(user) }

  context 'GET edit' do
    before do
      course.update!({ hidden_contact_attrs: ['title', 'nickname']})
    end
  end
end
