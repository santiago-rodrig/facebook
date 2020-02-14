require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#body_painted_if_devise' do

    # is well known that controller.controller_name returns the name of
    # the controller in question as a string. Let's test with different
    # strings

    context 'the controller is users/sessions_controller' do
      let(:controller_name) { 'sessions' }
      let(:controller_action) { 'new' }

      it 'returns the body with custom class' do
        expect(
          helper.body_painted_if_devise(controller_name, controller_action)
        ).to eq("<body class='full-black'>".html_safe)
      end
    end

    context 'the controller is users/registrations_controller' do
      let(:controller_name) { 'registrations' }

      context 'the action is new' do
        let(:controller_action) { 'new' }

        it 'returns the body with custom class' do
          expect(
            helper.body_painted_if_devise(controller_name, controller_action)
          ).to eq("<body class='full-black'>".html_safe)
        end
      end

      context 'the action is edit' do
        let(:controller_action) { 'edit' }

        it 'returns the body without a class' do
          expect(
            helper.body_painted_if_devise(controller_name, controller_action)
          ).to eq('<body>'.html_safe)
        end
      end
    end

    context 'the controller is some other' do
      let(:controller_name) { 'posts' }
      let(:controller_action) { 'show' }

      it 'returns the body without a class' do
        expect(
          helper.body_painted_if_devise(controller_name, controller_action)
        ).to eq('<body>'.html_safe)
      end
    end
  end
end
