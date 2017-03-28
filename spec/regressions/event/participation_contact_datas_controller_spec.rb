# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

# encoding:  utf-8

require 'spec_helper'

describe Event::ParticipationContactDatasController, type: :controller do

  let(:group) { groups(:top_layer) }

  let(:event) do
    course = Fabricate(:course, groups: [group])
    #course.dates << Fabricate(:event_date, event: course)
    course
  end

  let(:user) { people(:top_leader) }

  before { sign_in(user) }

  describe 'GET edit' do

    before do
      event.update!({ hidden_contact_attrs: ['address', 'nickname'] })
    end

    let(:dom) { Capybara::Node::Simple.new(response.body) }

    it 'does not show hidden contact fields' do
      get :edit, group_id: event.groups.first.id, event_id: event.id

      require 'pry'; binding.pry unless $pstop
      expect(dom).to have_selector('input#event_participation_contact_data_first_name')
      expect(dom).to have_selector('input#event_participation_contact_data_last_name')
      expect(dom).to have_selector('input#event_participation_contact_data_email')

      expect(dom).to have_no_selector('input#event_participation_contact_data_title')
      expect(dom).to have_no_selector('input#event_participation_contact_data_nickname')
    end

  end

end
