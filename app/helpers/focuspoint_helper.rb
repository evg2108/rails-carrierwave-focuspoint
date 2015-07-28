module FocuspointHelper
  def focuspoint_control(attachment, opts = {})
    attachment_instance = self.object.send(attachment)

    if(attachment_instance.is_a? CarrierWave::Uploader::Base)
      model_name = self.object.class.name.demodulize.underscore

      @template.content_tag(:div, class: 'focuspoint-control', style: 'display: none;') do
        @template.concat @template.image_tag(attachment_instance.url, class: 'focuspoint-control-image')
        @template.concat @template.image_tag('focuspoint-target.png', class: 'focuspoint-control-target')
        @template.concat @template.image_tag(attachment_instance.url, class: 'focuspoint-control-target-overlay')
        [:focus_x ,:focus_y].each do |attribute|
          @template.concat @template.hidden_field_tag("#{model_name}[#{attribute}]", nil, id: "#{model_name}_#{attribute}", class: attribute)
        end
      end
    end
  end
end

if defined? ActionView::Helpers::FormBuilder
  ActionView::Helpers::FormBuilder.class_eval do
    include FocuspointHelper
  end
end