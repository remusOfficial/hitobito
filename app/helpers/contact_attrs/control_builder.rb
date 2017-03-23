module ContactAttrs
  class ControlBuilder

    include ActionView::Helpers::OutputSafetyHelper

    def initialize(form, event)
      @f = form
      @event = event
    end

    def render
      safe_join(mandatory_contact_attrs)
    end

    private

    delegate :t, to: I18n

    attr_reader :f, :event

    def mandatory_contact_attrs
      Person.mandatory_contact_attrs.collect do |a|
        [f.label(a, attr_label(a), class: 'control-label'),
        radio_buttons(a, true, [:required]),
        line_break]
      end
    end

    def radio_buttons(attr, disabled = false, options = [:required, :optional, :hidden])
      f.content_tag(:div, class: 'controls') do
        safe_join(options.collect do |o|
          checked = options.size == 1
          radio_button(attr, disabled, o, checked)
        end)
      end
    end

    def radio_button(attr, disabled, option, checked = false)
      f.label(:attr, class: 'radio inline') do
        checked = checked ? checked : checked?(attr, option)
        options = {disabled: disabled, checked: checked}
        f.radio_button("contact_attrs[#{attr}]", option, options) +
          option_label(option)
      end
    end

    def checked?(attr, option)
      return event.required_contact_attrs.include?(attr) if option == :required
      return event.hidden_contact_attrs.include?(attr) if option == :hidden
      true
    end

    def option_label(option)
      t("activerecord.attributes.event/contact_attrs.#{option}")
    end

    def attr_label(attr)
      t("activerecord.attributes.person.#{attr}")
    end

    def line_break
      f.content_tag(:br)
    end

  end
end
