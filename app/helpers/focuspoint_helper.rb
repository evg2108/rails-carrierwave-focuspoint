module FocuspointHelper
  def focuspoint_control(attachment, opts = {})
    attachment_instance = self.object.send(attachment)

    if(attachment_instance.is_a? CarrierWave::Uploader::Base)
      @template.content_tag(:div, class: 'focuspoint-control', style: ('display: none;' if self.object.new_record?)) do
        @template.concat @template.content_tag(:img, nil, src: attachment_instance.url, class: 'focuspoint-control-image')
        @template.concat @template.image_tag('focuspoint-target.png', class: 'focuspoint-control-target')
        @template.concat @template.content_tag(:img, nil, src: attachment_instance.url, class: 'focuspoint-control-target-overlay')
        [:focus_x ,:focus_y].each do |attribute|
          @template.concat self.hidden_field attribute, class: attribute
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